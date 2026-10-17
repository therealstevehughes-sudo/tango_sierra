// Equipment library (2026-10-17): drafts a check pack for a make/model
// that isn't in VenuRite's library yet. Returned to the app as a DRAFT —
// a manager reviews, edits and approves it before it's saved or used, and
// is told to check it against the manufacturer's manual. Managers only.

import "@supabase/functions-js/edge-runtime.d.ts"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY")!
const ISSUER = "https://api.venurite.com/auth/v1"
const MANAGERS = ["venueManager", "regional", "executive"]

const SYSTEM_PROMPT = `You draft equipment-specific checks for UK commercial kitchens and bars, for a food-safety app.
Given a make and model (and its general type), list the routine checks a venue should do for THAT equipment: daily/weekly cleaning, filter or descale routines, seal/gasket checks, temperature readings where relevant, and safety checks.
Rules:
- Be conservative and generic where you are not sure of model-specific details. Never invent exact service intervals, temperatures or part names you are not confident about; say "as in the manufacturer's manual" instead.
- 3 to 6 checks. Each with 3-5 short action steps in plain English.
- frequency must be one of: daily, weekly, monthly, quarterly, perService.
- method "data" only when a reading is entered (then give min/max/unit where well established, e.g. fridges 8°C max), otherwise "tick".
- critical true only for food-safety or fire/gas safety checks.
Reply with JSON only:
{"checks":[{"title":"...","frequency":"daily","method":"tick","min":null,"max":null,"unit":null,"critical":false,"photo":false,"steps":["..."],"why":"...","if_fails":"..."}],"note":"one sentence: what to double-check in the manual"}`

const FREQS = new Set(["daily", "weekly", "monthly", "quarterly", "perService"])

Deno.serve(async (req: Request) => {
  if (req.headers.get("apikey") !== ANON_KEY) {
    return Response.json({ outcome: "error", error: "invalid or missing apikey" }, { status: 401 })
  }
  const token = (req.headers.get("Authorization") ?? "").replace(/^Bearer\s+/i, "")
  try {
    const { payload } = await jose.jwtVerify(token, new TextEncoder().encode(JWT_SECRET), { issuer: ISSUER })
    const tier = (payload.app_metadata as Record<string, unknown> | undefined)?.role_tier as string | undefined
    if (!tier || !MANAGERS.includes(tier)) throw new Error("not a manager")
  } catch {
    return Response.json({ outcome: "error", error: "only a manager can draft equipment checks" }, { status: 403 })
  }
  let body: { manufacturer?: string; model?: string; type_name?: string }
  try {
    body = await req.json()
  } catch {
    return Response.json({ outcome: "error", error: "invalid JSON body" }, { status: 400 })
  }
  const make = (body.manufacturer ?? "").trim().slice(0, 80)
  const model = (body.model ?? "").trim().slice(0, 80)
  if (!make || !model) return Response.json({ outcome: "error", error: "make and model are required" }, { status: 400 })

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
          { role: "user", content: `Make: ${make}\nModel: ${model}\nType: ${(body.type_name ?? "").slice(0, 60)}` },
        ],
      }),
    })
    if (!res.ok) return Response.json({ outcome: "error", error: await res.text() }, { status: 502 })
    const data = await res.json()
    const parsed = JSON.parse(data.choices[0].message.content as string)
    const s = (v: unknown) => (typeof v === "string" ? v.replace(/\s+/g, " ").trim() : "")
    const n = (v: unknown) => (typeof v === "number" && isFinite(v) ? v : null)
    const checks = (Array.isArray(parsed.checks) ? parsed.checks : [])
      .map((c: Record<string, unknown>) => ({
        title: s(c.title).slice(0, 80),
        frequency: FREQS.has(s(c.frequency)) ? s(c.frequency) : "weekly",
        method: c.method === "data" ? "data" : "tick",
        min: n(c.min),
        max: n(c.max),
        unit: s(c.unit) || null,
        critical: c.critical === true,
        photo: c.photo === true,
        steps: (Array.isArray(c.steps) ? c.steps : []).map(s).filter((x: string) => x).slice(0, 6),
        why: s(c.why).slice(0, 200),
        if_fails: s(c.if_fails).slice(0, 200),
      }))
      .filter((c: { title: string; steps: string[] }) => c.title && c.steps.length > 0)
      .slice(0, 6)
    if (checks.length === 0) return Response.json({ outcome: "error", error: "no usable checks - try again" }, { status: 502 })
    return Response.json({ outcome: "drafted", checks, note: s(parsed.note) })
  } catch (e) {
    return Response.json({ outcome: "error", error: e instanceof Error ? e.message : String(e) }, { status: 500 })
  }
})
