// Setup Wizard AI conversation (2026-10-17, founder-approved): a director
// types about their business ("we have 3 pubs in Kent and a cafe in
// Brighton, Jo runs Kent") and this turns it into a structured outline
// that pre-fills the wizard's forms. It never creates anything - the
// person checks and confirms every step. Directors only.

import "@supabase/functions-js/edge-runtime.d.ts"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY")!
const ISSUER = "https://api.venurite.com/auth/v1"

const VENUE_TYPES = [
  "Quick Service (QSR)", "Fast Casual", "Casual Dining", "Fine Dining", "Café",
  "Bakery / Patisserie", "Bar / Pub", "Gastropub", "Hotel",
  "Contract / Institutional Catering", "Event / Mobile / Street Food", "Dark / Ghost Kitchen",
]

const SYSTEM_PROMPT = `You help a UK hospitality business owner set up VenuRite, a food-safety app.
Turn what they write into JSON describing their business. Only include what they actually said or clearly implied - never invent names, addresses, emails or numbers. Leave things out when unsure.

JSON shape:
{
  "single_site": true|false|null,
  "regions": [{"name": "...", "manager_name": "...", "manager_email": "..."}],
  "branches": [{"name": "...", "address": "...", "region": "<region name or null>", "venue_types": ["<from list>"], "departments": ["Kitchen", "Bar", ...]}],
  "leaders": [{"name": "...", "email": "..."}],
  "staff_count_hint": <number or null>,
  "reply": "<one or two short friendly sentences saying what you understood and what to check next>"
}
Venue types must be chosen from: ${VENUE_TYPES.join("; ")}.
If they say "3 pubs in Kent" without names, create 3 branches named "Pub 1 (Kent)", "Pub 2 (Kent)", "Pub 3 (Kent)" so they can rename them, and say so in the reply.
Use UK English. Reply with JSON only.`

Deno.serve(async (req: Request) => {
  if (req.headers.get("apikey") !== ANON_KEY) {
    return Response.json({ outcome: "error", error: "invalid or missing apikey" }, { status: 401 })
  }
  const token = (req.headers.get("Authorization") ?? "").replace(/^Bearer\s+/i, "")
  try {
    const { payload } = await jose.jwtVerify(token, new TextEncoder().encode(JWT_SECRET), { issuer: ISSUER })
    const meta = payload.app_metadata as Record<string, unknown> | undefined
    if (meta?.role_tier !== "executive") throw new Error("not a director")
  } catch {
    return Response.json({ outcome: "error", error: "only a director can use setup help" }, { status: 403 })
  }
  let body: { message?: string; current?: unknown }
  try {
    body = await req.json()
  } catch {
    return Response.json({ outcome: "error", error: "invalid JSON body" }, { status: 400 })
  }
  const message = (body.message ?? "").trim().slice(0, 2000)
  if (!message) return Response.json({ outcome: "error", error: "say something about your business" }, { status: 400 })

  try {
    const res = await fetch("https://api.openai.com/v1/chat/completions", {
      method: "POST",
      headers: { Authorization: `Bearer ${OPENAI_API_KEY}`, "Content-Type": "application/json" },
      body: JSON.stringify({
        model: "gpt-4o-mini",
        temperature: 0.2,
        response_format: { type: "json_object" },
        messages: [
          { role: "system", content: SYSTEM_PROMPT },
          {
            role: "user",
            content: `What I've already entered (JSON, may be empty): ${JSON.stringify(body.current ?? {}).slice(0, 3000)}\n\nMy message: ${message}`,
          },
        ],
      }),
    })
    if (!res.ok) return Response.json({ outcome: "error", error: await res.text() }, { status: 502 })
    const data = await res.json()
    const outline = JSON.parse(data.choices[0].message.content as string)
    return Response.json({ outcome: "outline", outline })
  } catch (e) {
    return Response.json({ outcome: "error", error: e instanceof Error ? e.message : String(e) }, { status: 500 })
  }
})
