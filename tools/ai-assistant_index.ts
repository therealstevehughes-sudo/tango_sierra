// AI assistant (RAG) — grounded kitchen-compliance Q&A, agreed design in
// DECISIONS_LOG.md (2026-09-27). Staged here in the repo for review before
// deployment (the real copy lives at
// ~/tango-sierra/supabase/docker/volumes/functions/ai-assistant/index.ts
// on the VPS — no local functions/ dev mirror exists in this project, per
// established convention; this file is the staging/review copy only).
//
// Flow: embed the question -> check the cross-venue semantic answer cache
// (Layer 2, free) -> on a miss, check the org's usage cap (no cap enforced
// yet — Phase 4, deferred until real numbers are set) -> retrieve top
// compliance_chunks (guidance-biased) -> ask gpt-4o-mini, grounded ONLY in
// that context, with an explicit "say you don't know, don't guess"
// instruction -> cache the new answer for future reuse -> return.
//
// Compliance-critical guardrail (see DECISIONS_LOG.md's standing rule):
// this must NEVER answer from the model's general knowledge. A wrong
// food-safety answer is a real safety risk, not just a bad UX moment.

import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY")!
const ISSUER = "https://api.venurite.com/auth/v1"

const EMBEDDING_MODEL = "text-embedding-3-small"
const CHAT_MODEL = "gpt-4o-mini"
// Conservative on purpose — a false cache hit (returning a stale/wrong
// answer for a subtly different question) is worse than an occasional
// missed cache save in a compliance app. Tune after real Phase 3 usage.
const CACHE_SIMILARITY_THRESHOLD = 0.93
const RETRIEVAL_GUIDANCE_COUNT = 4
const RETRIEVAL_LEGISLATION_COUNT = 2

const SYSTEM_PROMPT = `You are VenuRite's kitchen-compliance assistant. Answer ONLY using the provided context below. Every factual claim must be traceable to the context. Always name the source document you're drawing from. If the context does not clearly answer the question, say so explicitly and tell the user to check with their manager or local Environmental Health Officer — never guess or use general knowledge.`

const supabaseAdmin = createClient(DB_URL, SERVICE_ROLE_KEY)

interface Claims {
  organisation_id?: number
  site_id?: number
}

async function embedText(text: string): Promise<number[]> {
  const response = await fetch("https://api.openai.com/v1/embeddings", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${OPENAI_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({ model: EMBEDDING_MODEL, input: text }),
  })
  if (!response.ok) {
    throw new Error(`embeddings API failed: ${await response.text()}`)
  }
  const data = await response.json()
  return data.data[0].embedding
}

interface ChunkResult {
  document_title: string
  source_category: string
  source_url: string | null
  content: string
}

async function retrieveChunks(embedding: number[], organisationId: number): Promise<ChunkResult[]> {
  const [guidance, legislation] = await Promise.all([
    supabaseAdmin.rpc("match_compliance_chunks", {
      query_embedding: embedding,
      match_count: RETRIEVAL_GUIDANCE_COUNT,
      caller_org_id: organisationId,
      category_filter: "guidance",
    }),
    supabaseAdmin.rpc("match_compliance_chunks", {
      query_embedding: embedding,
      match_count: RETRIEVAL_LEGISLATION_COUNT,
      caller_org_id: organisationId,
      category_filter: "legislation",
    }),
  ])
  if (guidance.error) throw new Error(`chunk retrieval (guidance) failed: ${guidance.error.message}`)
  if (legislation.error) throw new Error(`chunk retrieval (legislation) failed: ${legislation.error.message}`)
  return [...(guidance.data ?? []), ...(legislation.data ?? [])]
}

async function callChatModel(question: string, chunks: ChunkResult[]): Promise<string> {
  const contextBlock = chunks
    .map((c, i) => `[${i + 1}] Source: ${c.document_title}\n${c.content}`)
    .join("\n\n")

  const response = await fetch("https://api.openai.com/v1/chat/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${OPENAI_API_KEY}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      model: CHAT_MODEL,
      temperature: 0.1,
      messages: [
        { role: "system", content: SYSTEM_PROMPT },
        {
          role: "user",
          content: `Context:\n\n${contextBlock}\n\nQuestion: ${question}`,
        },
      ],
    }),
  })
  if (!response.ok) {
    throw new Error(`chat completion failed: ${await response.text()}`)
  }
  const data = await response.json()
  return data.choices[0].message.content as string
}

async function bumpUsage(
  organisationId: number,
  field: "paid_questions_count" | "cache_hit_count" | "fallback_count",
) {
  const periodStart = new Date()
  periodStart.setUTCDate(1)
  const periodStartStr = periodStart.toISOString().slice(0, 10)

  // Upsert-by-increment: read-then-write rather than a single atomic SQL
  // increment, matching this project's existing "compute derived state,
  // simple read/write" style elsewhere (no RPC needed for a low-contention
  // per-org-per-month counter). Not a hot path — one call per question.
  const { data: existing } = await supabaseAdmin
    .from("ai_usage")
    .select("id, paid_questions_count, cache_hit_count, fallback_count")
    .eq("organisation_id", organisationId)
    .eq("period_start", periodStartStr)
    .maybeSingle()

  if (existing) {
    await supabaseAdmin
      .from("ai_usage")
      .update({ [field]: (existing[field] ?? 0) + 1, updated_at: new Date().toISOString() })
      .eq("id", existing.id)
  } else {
    await supabaseAdmin.from("ai_usage").insert({
      organisation_id: organisationId,
      period_start: periodStartStr,
      [field]: 1,
    })
  }
}

Deno.serve(async (req: Request) => {
  const apikey = req.headers.get("apikey")
  if (apikey !== ANON_KEY) {
    return Response.json({ outcome: "error", error: "invalid or missing apikey" }, { status: 401 })
  }
  if (req.method !== "POST") {
    return Response.json({ outcome: "error", error: "method not allowed" }, { status: 405 })
  }

  const authHeader = req.headers.get("Authorization") ?? ""
  const callerToken = authHeader.replace(/^Bearer\s+/i, "")
  if (!callerToken) {
    return Response.json({ outcome: "error", error: "sign in first" }, { status: 401 })
  }

  let claims: Claims
  try {
    const secretKey = new TextEncoder().encode(JWT_SECRET)
    const verified = await jose.jwtVerify(callerToken, secretKey, { issuer: ISSUER })
    claims = (verified.payload.app_metadata as Claims) ?? {}
  } catch {
    return Response.json({ outcome: "error", error: "invalid session" }, { status: 401 })
  }

  if (!claims.organisation_id) {
    return Response.json({ outcome: "error", error: "no organisation on this session" }, { status: 403 })
  }
  const organisationId = claims.organisation_id

  let body: { question?: string }
  try {
    body = await req.json()
  } catch {
    return Response.json({ outcome: "error", error: "invalid JSON body" }, { status: 400 })
  }
  const question = body.question?.trim()
  if (!question) {
    return Response.json({ outcome: "error", error: "question is required" }, { status: 400 })
  }

  try {
    const questionEmbedding = await embedText(question)

    // Layer 2: cross-venue shared semantic cache.
    const cacheMatch = await supabaseAdmin.rpc("match_ai_answer_cache", {
      query_embedding: questionEmbedding,
      match_threshold: CACHE_SIMILARITY_THRESHOLD,
    })
    if (cacheMatch.error) throw new Error(`cache lookup failed: ${cacheMatch.error.message}`)

    if (cacheMatch.data && cacheMatch.data.length > 0) {
      const hit = cacheMatch.data[0]
      await supabaseAdmin
        .from("ai_answer_cache")
        .update({ hit_count: (hit as any).hit_count ?? 1, last_hit_at: new Date().toISOString() })
        .eq("id", hit.id)
      await bumpUsage(organisationId, "cache_hit_count")
      return Response.json({
        outcome: "cache_hit",
        answer: hit.answer_text,
        citation: { document: hit.citation_document, url: hit.citation_url },
      })
    }

    // Budget gate — no cap enforced yet (Phase 4, deferred until the
    // founder sets real numbers). The gate exists in the flow now so
    // Phase 4 only has to wire in a real comparison, not restructure this.

    // Layer 3: retrieve + generate.
    const chunks = await retrieveChunks(questionEmbedding, organisationId)
    if (chunks.length === 0) {
      return Response.json({
        outcome: "answer",
        answer:
          "I don't have anything in my compliance library that covers this. Please check with your manager or local Environmental Health Officer.",
        citation: null,
      })
    }

    const answer = await callChatModel(question, chunks)
    const primaryChunk = chunks[0]

    await supabaseAdmin.from("ai_answer_cache").insert({
      question_embedding: questionEmbedding,
      question_text: question,
      answer_text: answer,
      citation_document: primaryChunk.document_title,
      citation_url: primaryChunk.source_url,
      model_used: CHAT_MODEL,
    })
    await bumpUsage(organisationId, "paid_questions_count")

    return Response.json({
      outcome: "answer",
      answer,
      citation: { document: primaryChunk.document_title, url: primaryChunk.source_url },
    })
  } catch (e) {
    return Response.json(
      { outcome: "error", error: e instanceof Error ? e.message : String(e) },
      { status: 500 },
    )
  }
})
