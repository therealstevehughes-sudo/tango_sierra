// Setup Wizard branch search (2026-10-17, founder-approved tweak 2): looks
// up public Google Maps listings (via Apify) so a director can tick their
// own branches instead of typing every address. It only SUGGESTS - the
// person must tick each one; nothing is added on its own. Directors only,
// max 25 searches per business per day (claim_branch_search).

import "@supabase/functions-js/edge-runtime.d.ts"
import { createClient } from "jsr:@supabase/supabase-js@2"
import * as jose from "jsr:@panva/jose@6"

const ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY")!
const SERVICE_ROLE_KEY = Deno.env.get("SUPABASE_SERVICE_ROLE_KEY")!
const JWT_SECRET = Deno.env.get("JWT_SECRET")!
const DB_URL = Deno.env.get("SUPABASE_URL")!
const APIFY_TOKEN = Deno.env.get("APIFY_TOKEN")!
const ISSUER = "https://api.venurite.com/auth/v1"
const admin = createClient(DB_URL, SERVICE_ROLE_KEY)

Deno.serve(async (req: Request) => {
  if (req.headers.get("apikey") !== ANON_KEY) {
    return Response.json({ outcome: "error", error: "invalid or missing apikey" }, { status: 401 })
  }
  const token = (req.headers.get("Authorization") ?? "").replace(/^Bearer\s+/i, "")
  let org: number | undefined
  try {
    const { payload } = await jose.jwtVerify(token, new TextEncoder().encode(JWT_SECRET), { issuer: ISSUER })
    const meta = payload.app_metadata as Record<string, unknown> | undefined
    if (meta?.role_tier !== "executive") throw new Error("not a director")
    org = Number(meta?.organisation_id)
  } catch {
    return Response.json({ outcome: "error", error: "only a director can search for branches" }, { status: 403 })
  }

  let body: { query?: string; area?: string }
  try {
    body = await req.json()
  } catch {
    return Response.json({ outcome: "error", error: "invalid JSON body" }, { status: 400 })
  }
  const query = (body.query ?? "").trim().slice(0, 100)
  const area = (body.area ?? "").trim().slice(0, 100)
  if (query.length < 2) {
    return Response.json({ outcome: "error", error: "type your business name" }, { status: 400 })
  }

  const { data: allowed } = await admin.rpc("claim_branch_search", { p_org: org, p_query: `${query} | ${area}` })
  if (allowed !== true) {
    return Response.json({ outcome: "error", error: "search limit reached for today - add branches by hand" }, { status: 429 })
  }

  try {
    const res = await fetch(
      `https://api.apify.com/v2/acts/compass~crawler-google-places/run-sync-get-dataset-items?token=${APIFY_TOKEN}&timeout=90`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          searchStringsArray: [query],
          locationQuery: area || "United Kingdom",
          maxCrawledPlacesPerSearch: 20,
          language: "en",
          skipClosedPlaces: true,
          scrapePlaceDetailPage: false,
        }),
      },
    )
    if (!res.ok) {
      return Response.json({ outcome: "error", error: `search failed (${res.status})` }, { status: 502 })
    }
    const items = (await res.json()) as Record<string, unknown>[]
    const results = items
      .filter((x) => typeof x.title === "string")
      .map((x) => ({
        name: x.title as string,
        address: (x.address as string | undefined) ?? "",
        category: (x.categoryName as string | undefined) ?? "",
        place_id: (x.placeId as string | undefined) ?? "",
      }))
    return Response.json({ outcome: "found", results })
  } catch (e) {
    return Response.json({ outcome: "error", error: e instanceof Error ? e.message : String(e) }, { status: 500 })
  }
})
