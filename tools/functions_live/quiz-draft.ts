// Quiz drafting (2026-10-17, founder-approved R): when a venue edits a
// task's training guide or adds its own task, VenuRite's AI drafts that
// task's quiz questions FROM THE GUIDE TEXT ONLY. They're saved as
// "pending" through the caller's own session (save_task_quiz_drafts checks
// manager + venue access) and only go live once a manager approves them -
// same "never auto-publish unreviewed AI output" rule as SOP drafts.

import "@supabase/functions-js/edge-runtime.d.ts"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const ISSUER = "https://api.venurite.com/auth/v1"
const CHAT_MODEL = "gpt-4o-mini"
const MANAGER_TIERS = ["venueManager", "regional", "executive"]

const SYSTEM_PROMPT = `You write short multiple-choice quiz questions that check a hospitality worker has read and understood a task's training guide.

Rules:
- Use ONLY facts in the guide you are given. Never add rules, numbers or advice that are not in it.
- Write 6 questions. Each has exactly 1 right answer and 2 wrong answers.
- Plain, simple English for staff who may not speak English as a first language. Questions under 100 characters, answers under 70.
- Wrong answers must be clearly wrong according to the guide, but believable to someone who has not read it.
- Make the right and wrong answers about the same length and detail, so the longest answer is not a giveaway.
- No "all of the above", "none of the above", trick wording or double negatives.
- Cover different parts of the guide: the steps, the pass/fail figures, why it matters, and what to do if it fails.

Reply with JSON only: {"questions":[{"question":"...","right":"...","wrong":["...","..."]}]}`

type Draft = { question: string; right: string; wrong: string[] }

function clean(s: unknown): string {
  return typeof s === "string" ? s.replace(/\s+/g, " ").trim() : ""
}

function valid(d: Draft): boolean {
  const opts = [d.right, ...d.wrong]
  return d.question.length >= 8 && d.question.length <= 160 &&
    d.wrong.length >= 2 && d.wrong.length <= 3 &&
    opts.every((o) => o.length >= 1 && o.length <= 140) &&
    new Set(opts.map((o) => o.toLowerCase())).size === opts.length
}

Deno.serve(async (req: Request) => {
  if (req.headers.get("apikey") !== ANON_KEY) {
    return Response.json({ outcome: "error", error: "invalid or missing apikey" }, { status: 401 })
  }
  if (req.method !== "POST") {
    return Response.json({ outcome: "error", error: "method not allowed" }, { status: 405 })
  }

  const callerToken = (req.headers.get("Authorization") ?? "").replace(/^Bearer\s+/i, "")
  let tier: string | undefined
  try {
    const { payload } = await jose.jwtVerify(callerToken, new TextEncoder().encode(JWT_SECRET), { issuer: ISSUER })
    tier = (payload.app_metadata as Record<string, unknown> | undefined)?.role_tier as string | undefined
  } catch {
    return Response.json({ outcome: "error", error: "invalid session" }, { status: 401 })
  }
  if (!tier || !MANAGER_TIERS.includes(tier)) {
    return Response.json({ outcome: "error", error: "only a manager can draft quiz questions" }, { status: 403 })
  }

  let body: {
    site_id?: number
    template_group_id?: number
    task_title?: string
    guide_version?: string
    guide?: { steps?: string[]; why_it_matters?: string | null; if_it_fails?: string | null }
  }
  try {
    body = await req.json()
  } catch {
    return Response.json({ outcome: "error", error: "invalid JSON body" }, { status: 400 })
  }
  const steps = (body.guide?.steps ?? []).map(clean).filter((s) => s)
  if (!body.site_id || !body.template_group_id || !body.guide_version || steps.length === 0) {
    return Response.json({ outcome: "error", error: "site, task, guide version and guide steps are required" }, { status: 400 })
  }

  const guideText = [
    `Task: ${clean(body.task_title) || "(untitled task)"}`,
    "Steps:",
    ...steps.map((s, i) => `${i + 1}. ${s}`),
    body.guide?.why_it_matters ? `Why it matters: ${clean(body.guide.why_it_matters)}` : "",
    body.guide?.if_it_fails ? `If it fails: ${clean(body.guide.if_it_fails)}` : "",
  ].filter((l) => l).join("\n")

  let drafts: Draft[]
  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: { Authorization: `Bearer ${OPENAI_API_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        model: CHAT_MODEL,
        temperature: 0.3,
        response_format: { type: "json_object" },
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          { role: "user", content: guideText },
        ],
      }),
    })
    if (!response.ok) {
      return Response.json({ outcome: "error", error: await response.text() }, { status: 502 })
    }
    const data = await response.json()
    const parsed = JSON.parse(data.choices[0].message.content as string)
    drafts = (Array.isArray(parsed.questions) ? parsed.questions : [])
      .map((q: Record<string, unknown>) => ({
        question: clean(q.question),
        right: clean(q.right),
        wrong: (Array.isArray(q.wrong) ? q.wrong : []).map(clean).filter((w: string) => w),
      }))
      .filter(valid)
      .slice(0, 6)
  } catch (e) {
    return Response.json({ outcome: "error", error: e instanceof Error ? e.message : String(e) }, { status: 500 })
  }
  if (drafts.length < 3) {
    return Response.json({ outcome: "error", error: "the AI did not produce enough usable questions - try again" }, { status: 502 })
  }

  // Saved as the caller, so the database's own manager + venue checks apply.
  const save = await fetch(`${DB_URL}/rest/v1/rpc/save_task_quiz_drafts`, {
    method: "POST",
    headers: {
      apikey: ANON_KEY,
      Authorization: `Bearer ${callerToken}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      p_site_id: body.site_id,
      p_template_group_id: body.template_group_id,
      p_guide_version: body.guide_version,
      p_questions: drafts.map((d) => ({ question: d.question, options: [d.right, ...d.wrong] })),
    }),
  })
  if (!save.ok) {
    return Response.json({ outcome: "error", error: await save.text() }, { status: save.status })
  }
  return Response.json({ outcome: "drafted", saved: drafts.length })
})
