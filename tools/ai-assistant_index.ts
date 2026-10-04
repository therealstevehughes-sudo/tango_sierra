// AI assistant (RAG) — grounded kitchen-compliance Q&A, agreed design in
// DECISIONS_LOG.md (2026-09-27). Staged here in the repo for review before
// deployment (the real copy lives at
// ~/tango-sierra/supabase/docker/volumes/functions/ai-assistant/index.ts
// on the VPS — no local functions/ dev mirror exists in this project, per
// established convention; this file is the staging/review copy only).
//
// Flow: embed the question -> check the cross-venue semantic answer cache
// (Layer 2, free) -> on a miss, check the org's usage cap -> retrieve top
// compliance_chunks (guidance-biased) -> ask gpt-4o-mini, grounded ONLY in
// that context, with an explicit "say you don't know, don't guess"
// instruction -> cache the new answer for future reuse -> return.
//
// Usage cap (Phase 4, 2026-09-27) — real OpenAI cost per question is
// negligible (~$0.0006 worst-case uncached), so this isn't a cost-recovery
// mechanism, it's abuse protection + founder visibility. Two thresholds,
// both scaled by the org's billed_site_count (so a 5-branch org gets 5x a
// 1-branch org's allowance) and both counting only real paid_questions_count
// (cache hits stay free, matching bumpUsage's existing field split):
//   - 500/branch/month: crossing it once emails the founder via Postmark's
//     HTTP API (no charge, no in-app notification — there's no
//     backend-synced notification delivery mechanism in this app yet, and
//     building one just for this would be over-engineering for a founder-
//     only visibility signal).
//   - 1,500/branch/month: hard ceiling. Further questions return
//     outcome "limit_reached" without calling OpenAI at all (no embedding,
//     no retrieval, no chat completion — the block itself costs nothing).
//     No charge at this threshold either — see DECISIONS_LOG.md's Phase 4
//     entry for the real cost math behind not billing for this at all.
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
const POSTMARK_API_TOKEN = Deno.env.get("POSTMARK_API_TOKEN")!
const ISSUER = "https://api.venurite.com/auth/v1"

const EMBEDDING_MODEL = "text-embedding-3-small"
const CHAT_MODEL = "gpt-4o-mini"
// Conservative on purpose — a false cache hit (returning a stale/wrong
// answer for a subtly different question) is worse than an occasional
// missed cache save in a compliance app. Tune after real Phase 3 usage.
const CACHE_SIMILARITY_THRESHOLD = 0.93
const RETRIEVAL_GUIDANCE_COUNT = 4
const RETRIEVAL_LEGISLATION_COUNT = 2
// App-guide corpus (2026-10-04, direct founder request: the assistant
// should help with "the entire app", not just food-safety/compliance
// questions) — a third, separate category alongside guidance/legislation,
// first-party VenuRite content rather than external regulatory sources.
// See embed_compliance_library.py's own DOCUMENT_METADATA comment.
const RETRIEVAL_APP_GUIDE_COUNT = 4

// Usage cap thresholds — see the file-header comment for the reasoning.
const WARNING_QUESTIONS_PER_BRANCH = 500
const CEILING_QUESTIONS_PER_BRANCH = 1500
const FOUNDER_EMAIL = "steve@venurite.com"

const SUPPORTED_RESPONSE_LANGUAGES: Record<string, string> = {
  en: "English",
  pl: "Polish",
  ro: "Romanian",
  es: "Spanish",
  hr: "Croatian",
  de: "German",
  ar: "Arabic",
  zh: "Simplified Chinese",
  hi: "Hindi",
  ur: "Urdu",
}

const FALLBACK_ANSWERS: Record<string, { noContext: string; limitReached: string }> = {
  en: {
    noContext:
      "I don't have anything that covers this clearly. For a food-safety question, check with your manager or local Environmental Health Officer; for an app question, try \"Report a bug\" in the Help menu.",
    limitReached:
      "This venue has reached its AI question limit for this month. Contact VenuRite if you need this raised.",
  },
  pl: {
    noContext:
      "Nie mam niczego, co jasno to wyjasnia. W przypadku pytania o bezpieczenstwo zywnosci sprawdz to z kierownikiem albo lokalna inspekcja sanitarna; w przypadku pytania o aplikacje sprobuj \"Zglos blad\" w menu pomocy.",
    limitReached:
      "Ten lokal osiagnal miesieczny limit pytan AI. Skontaktuj sie z VenuRite, jesli limit trzeba zwiekszyc.",
  },
  ro: {
    noContext:
      "Nu am nimic care sa raspunda clar la aceasta intrebare. Pentru o intrebare despre siguranta alimentara, verifica cu managerul sau autoritatea sanitara locala; pentru o intrebare despre aplicatie, incearca \"Raporteaza o eroare\" din meniul de ajutor.",
    limitReached:
      "Aceasta locatie a atins limita lunara pentru intrebari AI. Contacteaza VenuRite daca ai nevoie de o limita mai mare.",
  },
  es: {
    noContext:
      "No tengo nada que responda claramente a esto. Para una pregunta de seguridad alimentaria, consultalo con un responsable o con la autoridad sanitaria local; para una pregunta sobre la aplicacion, prueba \"Reportar un error\" en el menu de ayuda.",
    limitReached:
      "Este local ha alcanzado el limite mensual de preguntas de IA. Contacta con VenuRite si necesitas aumentarlo.",
  },
  hr: {
    noContext:
      "Nemam nista sto jasno pokriva ovo pitanje. Za pitanje o sigurnosti hrane provjerite s voditeljem ili nadleznom sanitarnom inspekcijom; za pitanje o aplikaciji pokusajte \"Prijavi gresku\" u izborniku pomoci.",
    limitReached:
      "Ovaj objekt dosegnuo je mjesecno ogranicenje za AI pitanja. Kontaktirajte VenuRite ako trebate povecanje limita.",
  },
  de: {
    noContext:
      "Dazu habe ich nichts Eindeutiges. Bei einer Frage zur Lebensmittelsicherheit wenden Sie sich an eine Fuehrungskraft oder die zustaendige Lebensmittelueberwachung; bei einer Frage zur App versuchen Sie \"Fehler melden\" im Hilfemenue.",
    limitReached:
      "Dieser Standort hat das monatliche Limit fuer KI-Fragen erreicht. Kontaktieren Sie VenuRite, wenn das Limit erhoeht werden soll.",
  },
  ar: {
    noContext:
      "ليس لدي ما يجيب عن هذا بوضوح. بالنسبة لسؤال يتعلق بسلامة الغذاء، تحقق مع المدير أو الجهة الصحية المحلية المختصة؛ وبالنسبة لسؤال يتعلق بالتطبيق، جرّب \"الإبلاغ عن خطأ\" في قائمة المساعدة.",
    limitReached:
      "وصل هذا الموقع إلى الحد الشهري لأسئلة الذكاء الاصطناعي. تواصل مع VenuRite إذا كنت بحاجة إلى زيادة هذا الحد.",
  },
  zh: {
    noContext:
      "我没有能明确回答这个问题的内容。如果是食品安全问题，请向经理或当地卫生监管机构确认；如果是应用相关问题，请尝试帮助菜单中的“报告问题”。",
    limitReached: "此场所本月的 AI 提问次数已达上限。如需提高上限，请联系 VenuRite。",
  },
  hi: {
    noContext:
      "मेरे पास इसका स्पष्ट उत्तर देने वाली जानकारी नहीं है. खाद्य सुरक्षा से जुड़े सवाल के लिए अपने मैनेजर या स्थानीय स्वास्थ्य निरीक्षण प्राधिकरण से जांच लें; ऐप से जुड़े सवाल के लिए हेल्प मेनू में \"बग रिपोर्ट करें\" आज़माएं.",
    limitReached:
      "इस स्थान ने इस महीने AI सवालों की सीमा पूरी कर ली है. सीमा बढ़वाने की जरूरत हो तो VenuRite से संपर्क करें.",
  },
  ur: {
    noContext:
      "میرے پاس اس کا واضح جواب دینے والی معلومات نہیں ہیں. خوراک کی حفاظت سے متعلق سوال کے لیے اپنے مینیجر یا مقامی صحت کے معائنے کے ادارے سے تصدیق کریں؛ ایپ سے متعلق سوال کے لیے ہیلپ مینو میں \"بگ رپورٹ کریں\" آزمائیں.",
    limitReached:
      "اس مقام نے اس مہینے AI سوالات کی حد پوری کر لی ہے. حد بڑھوانے کی ضرورت ہو تو VenuRite سے رابطہ کریں.",
  },
}

// Broadened scope (2026-10-04, direct founder request) — this used to be
// introduced purely as a "kitchen-compliance assistant", which is why it
// could only ever help with food-safety questions: the context it was
// grounded in was 100% compliance/legislation documents. The grounding
// rule itself (never guess, never use general knowledge) is NOT relaxed —
// that's the real safety guardrail — only the persona and the pool of
// trustworthy context it's grounded in have grown, via the new app_guide
// category (see retrieveChunks() above).
const SYSTEM_PROMPT = `You are VenuRite's assistant — you help with both food-safety/compliance questions and questions about using the VenuRite app itself. Answer ONLY using the provided context below. Every factual claim must be traceable to the context. Do not mention or name the source document in your answer text — the source is shown separately in the app's own citation display. If the context does not clearly answer the question, say so explicitly; for a food-safety question, tell the user to check with their manager or local Environmental Health Officer; for an app-usage question, tell them to check with their manager or use "Report a bug" in the app's Help menu. Never guess or use general knowledge.`

function normalizeResponseLanguage(
  locale?: string,
  language?: string,
): { locale: string; language: string } {
  const normalizedLocale = (locale ?? "en").replace("-", "_").split("_")[0].toLowerCase()
  if (SUPPORTED_RESPONSE_LANGUAGES[normalizedLocale]) {
    return {
      locale: normalizedLocale,
      language: SUPPORTED_RESPONSE_LANGUAGES[normalizedLocale],
    }
  }

  const normalizedLanguage = (language ?? "").trim()
  const matched = Object.entries(SUPPORTED_RESPONSE_LANGUAGES).find(
    ([, value]) => value.toLowerCase() === normalizedLanguage.toLowerCase(),
  )
  if (matched) return { locale: matched[0], language: matched[1] }

  return { locale: "en", language: "English" }
}

function fallback(locale: string, key: "noContext" | "limitReached"): string {
  return (FALLBACK_ANSWERS[locale] ?? FALLBACK_ANSWERS.en)[key]
}

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
  const [guidance, legislation, appGuide] = await Promise.all([
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
    supabaseAdmin.rpc("match_compliance_chunks", {
      query_embedding: embedding,
      match_count: RETRIEVAL_APP_GUIDE_COUNT,
      caller_org_id: organisationId,
      category_filter: "app_guide",
    }),
  ])
  if (guidance.error) throw new Error(`chunk retrieval (guidance) failed: ${guidance.error.message}`)
  if (legislation.error) throw new Error(`chunk retrieval (legislation) failed: ${legislation.error.message}`)
  if (appGuide.error) throw new Error(`chunk retrieval (app_guide) failed: ${appGuide.error.message}`)
  return [...(guidance.data ?? []), ...(legislation.data ?? []), ...(appGuide.data ?? [])]
}

async function callChatModel(
  question: string,
  chunks: ChunkResult[],
  responseLanguage: string,
): Promise<string> {
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
          content:
            `Respond in ${responseLanguage}. If the user's question is in a different language, still respond in ${responseLanguage} unless the user explicitly asks for another language. Keep numbers, temperatures, legal thresholds, and safety-critical detail exact.\n\n` +
            `Context:\n\n${contextBlock}\n\nQuestion: ${question}`,
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

  let newCount = 1
  if (existing) {
    newCount = (existing[field] ?? 0) + 1
    await supabaseAdmin
      .from("ai_usage")
      .update({ [field]: newCount, updated_at: new Date().toISOString() })
      .eq("id", existing.id)
  } else {
    await supabaseAdmin.from("ai_usage").insert({
      organisation_id: organisationId,
      period_start: periodStartStr,
      [field]: 1,
    })
  }
  return newCount
}

async function sendFounderWarningEmail(organisationId: number, count: number, ceiling: number) {
  // Best-effort — a Postmark failure must never break the actual question
  // being answered, so this is fire-and-forget with its own try/catch,
  // never awaited into the caller's own error path.
  try {
    await fetch("https://api.postmarkapp.com/email", {
      method: "POST",
      headers: {
        Accept: "application/json",
        "Content-Type": "application/json",
        "X-Postmark-Server-Token": POSTMARK_API_TOKEN,
      },
      body: JSON.stringify({
        From: FOUNDER_EMAIL,
        To: FOUNDER_EMAIL,
        Subject: `VenuRite AI usage: organisation ${organisationId} crossed ${WARNING_QUESTIONS_PER_BRANCH}/branch`,
        TextBody:
          `Organisation ${organisationId} has asked ${count} AI questions this month ` +
          `(warning threshold: ${WARNING_QUESTIONS_PER_BRANCH}/branch, hard ceiling: ${ceiling}). ` +
          `No charge has been made — this is visibility only.`,
      }),
    })
  } catch {
    // swallow — see comment above
  }
}

interface UsageCapResult {
  atCeiling: boolean
  justCrossedWarning: boolean
  currentCount: number
  ceiling: number
}

async function checkUsageCap(organisationId: number): Promise<UsageCapResult> {
  const { data: subscription } = await supabaseAdmin
    .from("subscriptions")
    .select("billed_site_count")
    .eq("organisation_id", organisationId)
    .maybeSingle()
  const billedSiteCount = subscription?.billed_site_count ?? 1

  const periodStart = new Date()
  periodStart.setUTCDate(1)
  const periodStartStr = periodStart.toISOString().slice(0, 10)

  const { data: usage } = await supabaseAdmin
    .from("ai_usage")
    .select("paid_questions_count")
    .eq("organisation_id", organisationId)
    .eq("period_start", periodStartStr)
    .maybeSingle()
  const currentCount = usage?.paid_questions_count ?? 0

  const warning = WARNING_QUESTIONS_PER_BRANCH * billedSiteCount
  const ceiling = CEILING_QUESTIONS_PER_BRANCH * billedSiteCount

  return {
    atCeiling: currentCount >= ceiling,
    // Fires once: true only on the exact question that takes the count to
    // the threshold, not on every question above it.
    justCrossedWarning: currentCount + 1 === warning,
    currentCount,
    ceiling,
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

  let body: { question?: string; response_locale?: string; response_language?: string }
  try {
    body = await req.json()
  } catch {
    return Response.json({ outcome: "error", error: "invalid JSON body" }, { status: 400 })
  }
  const question = body.question?.trim()
  if (!question) {
    return Response.json({ outcome: "error", error: "question is required" }, { status: 400 })
  }
  const responseLanguage = normalizeResponseLanguage(body.response_locale, body.response_language)

  try {
    const questionEmbedding = await embedText(question)

    // Layer 2: cross-venue shared semantic cache.
    const cacheMatch = await supabaseAdmin.rpc("match_ai_answer_cache", {
      query_embedding: questionEmbedding,
      match_threshold: CACHE_SIMILARITY_THRESHOLD,
      response_locale_filter: responseLanguage.locale,
    })
    if (cacheMatch.error) throw new Error(`cache lookup failed: ${cacheMatch.error.message}`)

    if (cacheMatch.data && cacheMatch.data.length > 0) {
      const hit = cacheMatch.data[0]
      await supabaseAdmin
        .from("ai_answer_cache")
        .update({ hit_count: ((hit as any).hit_count ?? 0) + 1, last_hit_at: new Date().toISOString() })
        .eq("id", hit.id)
      await bumpUsage(organisationId, "cache_hit_count")
      return Response.json({
        outcome: "cache_hit",
        answer: hit.answer_text,
        citation: { document: hit.citation_document, url: hit.citation_url },
      })
    }

    // Usage cap gate (Phase 4) — checked after the free cache-hit path,
    // before any paid OpenAI call is made.
    const cap = await checkUsageCap(organisationId)
    if (cap.atCeiling) {
      return Response.json({
        outcome: "limit_reached",
        answer: fallback(responseLanguage.locale, "limitReached"),
      })
    }

    // Layer 3: retrieve + generate.
    const chunks = await retrieveChunks(questionEmbedding, organisationId)
    if (chunks.length === 0) {
      return Response.json({
        outcome: "answer",
        answer: fallback(responseLanguage.locale, "noContext"),
        citation: null,
      })
    }

    const answer = await callChatModel(question, chunks, responseLanguage.language)
    const primaryChunk = chunks[0]

    await supabaseAdmin.from("ai_answer_cache").insert({
      question_embedding: questionEmbedding,
      question_text: question,
      answer_text: answer,
      response_locale: responseLanguage.locale,
      response_language: responseLanguage.language,
      citation_document: primaryChunk.document_title,
      citation_url: primaryChunk.source_url,
      model_used: CHAT_MODEL,
    })
    await bumpUsage(organisationId, "paid_questions_count")
    if (cap.justCrossedWarning) {
      await sendFounderWarningEmail(organisationId, cap.currentCount + 1, cap.ceiling)
    }

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
