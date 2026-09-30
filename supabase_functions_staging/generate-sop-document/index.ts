// SOP/HACCP AI-assisted document generation (Phase 2, 2026-09-30).
//
// Deliberately NOT the same shape as ai-assistant's RAG Q&A — that
// function retrieves from compliance_chunks and is only ever grounded,
// citable answers to a specific question. Drafting a full SOP document is
// synthesis, not retrieval: there's no single passage to cite for "how do
// we structure our cleaning schedule," it's genuinely generated content
// from a template + the venue's own details. Because of that, this is
// explicitly NOT presented as grounded/citable in the app - it's a first
// draft a manager must read, edit and approve before it's a real
// procedure (see MenuItemRepository.approve's own "never auto-published"
// reasoning for the same principle applied to allergen tags).
//
// No usage cap here (unlike ai-assistant) - this is a manager-triggered,
// low-frequency action (drafting a handful of SOPs, not a per-question
// chat), not a per-question cost/abuse concern.

import "@supabase/functions-js/edge-runtime.d.ts"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY")!
const ISSUER = "https://api.venurite.com/auth/v1"

const CHAT_MODEL = "gpt-4o-mini"

const TEMPLATE_PROMPTS: Record<string, string> = {
  cleaningSchedule:
    "a Cleaning Schedule SOP covering daily, weekly and periodic cleaning tasks for a commercial kitchen, including what to clean, how often, the method, and who is responsible",
  allergenControl:
    "an Allergen Control SOP covering safe ingredient storage, avoiding cross-contamination during preparation, labelling, and how staff should respond to a customer allergen query",
  deliveryAndStorage:
    "a Delivery and Storage SOP covering checking deliveries on arrival (temperature, damage, quantity), correct storage temperatures and stock rotation (FIFO)",
  personalHygiene:
    "a Personal Hygiene SOP covering handwashing, protective clothing, illness reporting, and jewellery/wound-covering policy for kitchen staff",
  pestControl:
    "a Pest Control SOP covering prevention measures, signs of pest activity to watch for, and the escalation process if pest activity is found",
}

const SYSTEM_PROMPT = `You are helping a UK hospitality venue draft a first-draft Standard Operating Procedure (SOP) document, grounded in general UK food safety practice (Food Standards Agency guidance, HACCP principles). This is a STARTING DRAFT ONLY - it will be reviewed and edited by the venue's own manager before use, so write it as a solid, practical first draft, not a final legal document. Structure it with clear headings: Purpose, Scope, Procedure (numbered steps), Responsible Role(s), and Review Frequency. Do not invent venue-specific details you weren't given - use sensible general defaults and note in the text where the manager should confirm venue-specific details (e.g. exact temperatures, named responsible staff). Plain text output, no markdown formatting characters.`

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
  try {
    const secretKey = new TextEncoder().encode(JWT_SECRET)
    await jose.jwtVerify(callerToken, secretKey, { issuer: ISSUER })
  } catch {
    return Response.json({ outcome: "error", error: "invalid session" }, { status: 401 })
  }

  let body: { template_type?: string; site_name?: string; extra_context?: string }
  try {
    body = await req.json()
  } catch {
    return Response.json({ outcome: "error", error: "invalid JSON body" }, { status: 400 })
  }

  const templateType = body.template_type
  const templateDescription = templateType ? TEMPLATE_PROMPTS[templateType] : undefined
  if (!templateDescription) {
    return Response.json(
      { outcome: "error", error: "template_type is required and must be a known template" },
      { status: 400 },
    )
  }
  const siteName = body.site_name?.trim() || "this venue";
  const extraContext = body.extra_context?.trim();

  const userPrompt = `Draft ${templateDescription} for "${siteName}".${
    extraContext ? `\n\nAdditional details from the manager: ${extraContext}` : ""
  }`

  try {
    const response = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: {
        Authorization: `Bearer ${OPENAI_API_KEY}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: CHAT_MODEL,
        temperature: 0.3,
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          { role: "user", content: userPrompt },
        ],
      }),
    })
    if (!response.ok) {
      const errText = await response.text()
      return Response.json({ outcome: "error", error: errText }, { status: 502 })
    }
    const data = await response.json()
    const content = data.choices[0].message.content as string
    return Response.json({ outcome: "generated", content })
  } catch (e) {
    return Response.json(
      { outcome: "error", error: e instanceof Error ? e.message : String(e) },
      { status: 500 },
    )
  }
})
