// Voice-to-text for notes (2026-09-27) — proxies a short recorded clip to
// OpenAI's transcription API and returns plain text. Staged here for
// review (the real deployed copy lives at
// ~/tango-sierra/supabase/docker/volumes/functions/transcribe-audio/index.ts
// on the VPS, same convention as tools/ai-assistant_index.ts).
//
// This function reads/writes no tenant data — it only proxies to OpenAI —
// so auth only needs to confirm "a real, current VenuRite session" (PIN or
// GoTrue), no organisation/site scoping, same shape as ai-assistant's own
// auth block but without the organisation_id claim requirement.
//
// The transcribed text ALWAYS lands as plain, editable text in the app —
// this function has no opinion on that; it only ever returns {text}, never
// anything that could be mistaken for an instruction to auto-submit.

import "@supabase/functions-js/edge-runtime.d.ts"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const OPENAI_API_KEY = Deno.env.get("OPENAI_API_KEY")!
const ISSUER = "https://api.venurite.com/auth/v1"

// Confirmed live against OpenAI's current API docs 2026-09-27 — cheap
// (~$0.003/min), built on gpt-4o-mini's audio capabilities, better WER
// than classic whisper-1 on ordinary speech. Re-confirm if this function
// is ever revisited long after this date, per the same "don't trust a
// stale model name" discipline ai-assistant's own constants follow.
const TRANSCRIPTION_MODEL = "gpt-4o-mini-transcribe"

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

  let incoming: FormData
  try {
    incoming = await req.formData()
  } catch {
    return Response.json({ outcome: "error", error: "expected multipart/form-data" }, { status: 400 })
  }

  const audio = incoming.get("audio")
  if (!(audio instanceof File)) {
    return Response.json({ outcome: "error", error: "audio file is required" }, { status: 400 })
  }

  try {
    const outgoing = new FormData()
    outgoing.set("file", audio, audio.name || "clip.wav")
    outgoing.set("model", TRANSCRIPTION_MODEL)

    const response = await fetch("https://api.openai.com/v1/audio/transcriptions", {
      method: "POST",
      // No Content-Type header -- fetch sets the multipart boundary
      // itself for a FormData body; overriding it here would break the
      // encoding, same reasoning as the client side's own upload call.
      headers: { Authorization: `Bearer ${OPENAI_API_KEY}` },
      body: outgoing,
    })
    if (!response.ok) {
      return Response.json({ outcome: "error", error: await response.text() }, { status: 502 })
    }
    const data = await response.json()
    return Response.json({ outcome: "transcribed", text: data.text as string })
  } catch (e) {
    return Response.json(
      { outcome: "error", error: e instanceof Error ? e.message : String(e) },
      { status: 500 },
    )
  }
})
