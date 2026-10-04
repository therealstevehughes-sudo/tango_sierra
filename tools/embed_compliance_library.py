#!/usr/bin/env python3
"""Chunk and embed compliance_library/ into public.compliance_chunks.

Run manually, occasionally — not part of any live request path.
Idempotent: re-running deletes and reinserts by source_document, so fixing
one guidance file never requires a full corpus re-embed.

Requires environment variables:
    OPENAI_API_KEY      - same key used by the ai-assistant Edge Function
    SUPABASE_DB_URL      - postgresql://postgres:<password>@<host>:<port>/postgres
                            (service-role/direct DB connection, bypasses RLS)

Usage:
    python tools/embed_compliance_library.py
    python tools/embed_compliance_library.py --dry-run   # parse+chunk only, no API calls, no writes
"""

from __future__ import annotations

import argparse
import os
import re
import sys
import time
from dataclasses import dataclass
from pathlib import Path

import pdfplumber
import psycopg2
import tiktoken
from bs4 import BeautifulSoup
from openai import OpenAI, RateLimitError
from pypdf import PdfReader

EMBEDDING_MODEL = "text-embedding-3-small"
EMBEDDING_DIMENSIONS = 1536
CHUNK_TARGET_TOKENS = 600
CHUNK_OVERLAP_TOKENS = 90
# A new OpenAI org's default rate limit is a low 40,000 tokens/minute for
# embeddings (found the hard way: a 100-chunk batch of this corpus's
# ~600-token chunks requested ~64,500 tokens in one call and got a 429).
# 20 chunks/batch keeps a single request comfortably under that ceiling
# even for the largest chunks; the retry/backoff below is the real
# safety net for any request that still gets rate-limited.
EMBED_BATCH_SIZE = 20

REPO_ROOT = Path(__file__).resolve().parent.parent
LIBRARY_ROOT = REPO_ROOT / "compliance_library"

# Manifest metadata, kept in code rather than re-parsed from MANIFEST.md's
# markdown table — the table is for humans; this is the one place a new
# document's category/title/source_url need to be added when the corpus
# grows. Deliberately explicit rather than "clever" markdown parsing.
DOCUMENT_METADATA: dict[str, dict[str, str]] = {
    # legislation/ — citation source, not the main retrieval corpus
    "legislation/food_safety_hygiene_england_regs_2013.pdf": {
        "category": "legislation",
        "title": "The Food Safety and Hygiene (England) Regulations 2013",
        "url": "https://www.legislation.gov.uk/uksi/2013/2996/contents",
    },
    "legislation/food_hygiene_scotland_regs_2006.pdf": {
        "category": "legislation",
        "title": "The Food Hygiene (Scotland) Regulations 2006",
        "url": "https://www.legislation.gov.uk/ssi/2006/3/contents",
    },
    "legislation/food_hygiene_wales_regs_2006.pdf": {
        "category": "legislation",
        "title": "The Food Hygiene (Wales) Regulations 2006",
        "url": "https://www.legislation.gov.uk/wsi/2006/31/contents",
    },
    "legislation/food_hygiene_ni_regs_2006.pdf": {
        "category": "legislation",
        "title": "The Food Hygiene Regulations (Northern Ireland) 2006",
        "url": "https://www.legislation.gov.uk/nisr/2006/3/contents",
    },
    "legislation/regulation_ec_852_2004_hygiene_foodstuffs_retained.pdf": {
        "category": "legislation",
        "title": "Regulation (EC) No 852/2004 on the hygiene of foodstuffs (retained UK law)",
        "url": "https://www.legislation.gov.uk/eur/2004/852/contents",
    },
    "legislation/regulation_ec_178_2002_general_food_law_retained.pdf": {
        "category": "legislation",
        "title": "Regulation (EC) No 178/2002 — General Food Law (retained UK law)",
        "url": "https://www.legislation.gov.uk/eur/2002/178/contents",
    },
    "legislation/food_safety_temperature_control_regs_1995.pdf": {
        "category": "legislation",
        "title": "The Food Safety (Temperature Control) Regulations 1995",
        "url": "https://www.legislation.gov.uk/uksi/1995/2200/contents/made",
    },
    "legislation/food_information_regs_2014.pdf": {
        "category": "legislation",
        "title": "The Food Information Regulations 2014",
        "url": "https://www.legislation.gov.uk/uksi/2014/1855/contents",
    },
    "legislation/health_safety_at_work_act_1974.pdf": {
        "category": "legislation",
        "title": "Health and Safety at Work etc. Act 1974",
        "url": "https://www.legislation.gov.uk/ukpga/1974/37/contents",
    },
    "legislation/regulatory_reform_fire_safety_order_2005.pdf": {
        "category": "legislation",
        "title": "Regulatory Reform (Fire Safety) Order 2005",
        "url": "https://www.legislation.gov.uk/uksi/2005/1541/contents",
    },
    "legislation/gas_safety_installation_use_regs_1998.pdf": {
        "category": "legislation",
        "title": "Gas Safety (Installation and Use) Regulations 1998",
        "url": "https://www.legislation.gov.uk/uksi/1998/2451/contents",
    },
    "legislation/environmental_protection_act_1990.pdf": {
        "category": "legislation",
        "title": "Environmental Protection Act 1990 (s.34 Duty of Care)",
        "url": "https://www.legislation.gov.uk/ukpga/1990/43/contents",
    },
    "legislation/workplace_health_safety_welfare_regs_1992.pdf": {
        "category": "legislation",
        "title": "Workplace (Health, Safety and Welfare) Regulations 1992",
        "url": "https://www.legislation.gov.uk/uksi/1992/3004/contents",
    },
    "legislation/manual_handling_operations_regs_1992.pdf": {
        "category": "legislation",
        "title": "Manual Handling Operations Regulations 1992",
        "url": "https://www.legislation.gov.uk/uksi/1992/2793/contents",
    },
    # guidance/ — the main retrieval corpus
    "guidance/fsa_safer_food_better_business_caterers_pack.pdf": {
        "category": "guidance",
        "title": "Safer Food Better Business (SFBB) for Caterers",
        "url": "https://www.food.gov.uk/business-guidance/safer-food-better-business-for-caterers",
    },
    "guidance/fsa_food_law_code_of_practice_england.pdf": {
        "category": "guidance",
        "title": "Food Law Code of Practice (England)",
        "url": "https://www.gov.uk/government/publications/food-law-code-of-practice-and-guidance",
    },
    "guidance/fsa_fhrs_brand_standard.pdf": {
        "category": "guidance",
        "title": "Food Hygiene Rating Scheme — Brand Standard",
        "url": "https://www.gov.uk/government/publications/guidance-on-implementation-and-operation-of-the-food-hygiene-rating-scheme-the-brand-standard-and-statutory-guidance",
    },
    "guidance/fsa_allergen_guidance.html": {
        "category": "guidance",
        "title": "FSA Allergen Guidance for Food Businesses",
        "url": "https://www.food.gov.uk/business-guidance/allergen-guidance-for-food-businesses",
    },
    "guidance/fsa_ppds_labelling_guidance.html": {
        "category": "guidance",
        "title": "Labelling guidance for prepacked for direct sale (PPDS) food",
        "url": "https://www.gov.uk/government/publications/labelling-guidance-for-prepacked-for-direct-sale-ppds-food-products",
    },
    "guidance/fsa_how_food_hygiene_ratings_work.html": {
        "category": "guidance",
        "title": "How Food Hygiene Ratings work",
        "url": "https://www.food.gov.uk/business-guidance/how-food-hygiene-ratings-work",
    },
    "guidance/hse_indg136_coshh_brief_guide.pdf": {
        "category": "guidance",
        "title": "HSE INDG136 — COSHH: a brief guide to the Regulations",
        "url": "https://www.hse.gov.uk/pubns/indg136.htm",
    },
    "guidance/hse_indg458_legionnaires_brief_guide.pdf": {
        "category": "guidance",
        "title": "HSE INDG458 — Legionnaires' disease: a brief guide for dutyholders",
        "url": "https://www.hse.gov.uk/pubns/indg458.htm",
    },
    "guidance/hse_indg143_manual_handling_brief_guide.pdf": {
        "category": "guidance",
        "title": "HSE INDG143 — Getting to grips with manual handling",
        "url": "https://www.hse.gov.uk/pubns/indg143.htm",
    },
    # app_guide/ — a separate category (2026-10-04, direct founder request:
    # the AI assistant should help with "the entire app", not just food
    # safety/compliance questions). Own category rather than folding into
    # "guidance" so citations can visibly distinguish "this came from the
    # app guide" from "this came from food-safety guidance" — see
    # ai-assistant_index.ts's own retrieveChunks() for the matching third
    # retrieval call. First-party content (no external source URL).
    "app_guide/staff_guide.html": {
        "category": "app_guide",
        "title": "VenuRite Staff Guide",
    },
    "app_guide/manager_guide.html": {
        "category": "app_guide",
        "title": "VenuRite Manager & Leadership Guide",
    },
}

_encoder = tiktoken.get_encoding("cl100k_base")


def count_tokens(text: str) -> int:
    return len(_encoder.encode(text))


@dataclass
class Chunk:
    source_document: str
    source_category: str
    document_title: str
    section_heading: str | None
    chunk_index: int
    content: str
    content_tokens: int
    source_url: str | None


def extract_pdf_sections(path: Path) -> list[tuple[str | None, str]]:
    """Returns [(heading_or_none, page_text), ...] — one entry per page.

    Page-level granularity is enough for `section_heading`: real heading
    detection inside a PDF's plain-text extraction is unreliable (no
    reliable font-size/style signal survives pypdf's extraction), so this
    uses the first short, title-cased line on a page as a best-effort
    heading rather than pretending to a stronger structural parse than the
    format actually supports.
    """
    reader = PdfReader(str(path))
    sections: list[tuple[str | None, str]] = []
    plumber_doc = None  # opened lazily — only if pypdf chokes on a page

    for page_index, page in enumerate(reader.pages):
        try:
            text = (page.extract_text() or "").strip()
        except Exception as e:
            # Real gotcha found on the SFBB pack (guidance/fsa_safer_food_
            # better_business_caterers_pack.pdf): a malformed FontDescriptor
            # (both /FontFile and /FontFile3 present, which pypdf's font
            # parser treats as ambiguous and refuses) crashes extract_text()
            # outright on at least one page. Rather than let one bad font
            # in one PDF kill the whole corpus's extraction, fall back to
            # pdfplumber (a different parsing path, unaffected by this
            # specific pypdf font-parsing limitation) for just this page.
            print(
                f"    pypdf failed on page {page_index + 1} ({e.__class__.__name__}), "
                "falling back to pdfplumber for this page",
                file=sys.stderr,
            )
            if plumber_doc is None:
                plumber_doc = pdfplumber.open(str(path))
            try:
                text = (plumber_doc.pages[page_index].extract_text() or "").strip()
            except Exception as e2:
                print(
                    f"    pdfplumber also failed on page {page_index + 1} "
                    f"({e2.__class__.__name__}) — skipping this page",
                    file=sys.stderr,
                )
                text = ""

        if not text:
            continue
        heading = None
        first_line = text.splitlines()[0].strip()
        if 0 < len(first_line) < 80 and not first_line.endswith((".", ",", ";")):
            heading = first_line
        sections.append((heading, text))

    if plumber_doc is not None:
        plumber_doc.close()
    return sections


def extract_html_sections(path: Path) -> list[tuple[str | None, str]]:
    """Returns [(heading_or_none, section_text), ...], split on h1-h4."""
    soup = BeautifulSoup(path.read_text(encoding="utf-8", errors="ignore"), "html.parser")
    for tag in soup(["script", "style", "nav", "header", "footer"]):
        tag.decompose()

    sections: list[tuple[str | None, str]] = []
    current_heading: str | None = None
    current_parts: list[str] = []

    def flush() -> None:
        text = " ".join(p.strip() for p in current_parts if p.strip())
        text = re.sub(r"\s+", " ", text).strip()
        if text:
            sections.append((current_heading, text))

    body = soup.body or soup
    for el in body.find_all(["h1", "h2", "h3", "h4", "p", "li"]):
        if el.name in ("h1", "h2", "h3", "h4"):
            flush()
            current_parts = []
            current_heading = el.get_text(strip=True) or None
        else:
            current_parts.append(el.get_text(" ", strip=True))
    flush()
    return sections


def chunk_sections(sections: list[tuple[str | None, str]]) -> list[tuple[str | None, str]]:
    """Merge/split (heading, text) sections into ~CHUNK_TARGET_TOKENS chunks.

    Prefers section boundaries; only splits mid-section (on sentence
    boundaries) when a single section exceeds the target size. A cited
    chunk should read as a complete thought, not a token-count-cut
    fragment — this is a compliance app, and a citation that ends
    mid-sentence undermines its own credibility.
    """
    chunks: list[tuple[str | None, str]] = []
    buffer_heading: str | None = None
    buffer_text = ""

    def buffer_tokens() -> int:
        return count_tokens(buffer_text)

    for heading, text in sections:
        text_tokens = count_tokens(text)

        if text_tokens > CHUNK_TARGET_TOKENS * 1.5:
            if buffer_text:
                chunks.append((buffer_heading, buffer_text))
                buffer_heading, buffer_text = None, ""
            sentences = re.split(r"(?<=[.!?])\s+", text)
            piece = ""
            for sentence in sentences:
                if count_tokens(piece + " " + sentence) > CHUNK_TARGET_TOKENS and piece:
                    chunks.append((heading, piece.strip()))
                    overlap_words = piece.split()[-15:]
                    piece = " ".join(overlap_words) + " " + sentence
                else:
                    piece = (piece + " " + sentence).strip()
            if piece.strip():
                chunks.append((heading, piece.strip()))
            continue

        if buffer_tokens() + text_tokens > CHUNK_TARGET_TOKENS and buffer_text:
            chunks.append((buffer_heading, buffer_text))
            buffer_heading, buffer_text = heading, text
        else:
            if not buffer_text:
                buffer_heading = heading
            buffer_text = (buffer_text + "\n\n" + text).strip()

    if buffer_text:
        chunks.append((buffer_heading, buffer_text))

    return chunks


def build_chunks_for_document(rel_path: str, meta: dict[str, str]) -> list[Chunk]:
    full_path = LIBRARY_ROOT / rel_path
    if not full_path.exists():
        print(f"  SKIP (file not found): {rel_path}", file=sys.stderr)
        return []

    if full_path.suffix == ".pdf":
        sections = extract_pdf_sections(full_path)
    elif full_path.suffix == ".html":
        sections = extract_html_sections(full_path)
    else:
        print(f"  SKIP (unsupported type): {rel_path}", file=sys.stderr)
        return []

    raw_chunks = chunk_sections(sections)
    return [
        Chunk(
            source_document=rel_path,
            source_category=meta["category"],
            document_title=meta["title"],
            section_heading=heading,
            chunk_index=i,
            content=content,
            content_tokens=count_tokens(content),
            source_url=meta.get("url"),
        )
        for i, (heading, content) in enumerate(raw_chunks)
        if content.strip()
    ]


def embed_batch(client: OpenAI, texts: list[str], max_retries: int = 5) -> list[list[float]]:
    for attempt in range(max_retries):
        try:
            response = client.embeddings.create(model=EMBEDDING_MODEL, input=texts)
            return [item.embedding for item in response.data]
        except RateLimitError:
            if attempt == max_retries - 1:
                raise
            wait = 2**attempt  # 1s, 2s, 4s, 8s, 16s
            print(f"    rate limited, retrying in {wait}s...", file=sys.stderr)
            time.sleep(wait)
    raise RuntimeError("unreachable")


def main() -> None:
    parser = argparse.ArgumentParser()
    parser.add_argument("--dry-run", action="store_true", help="parse+chunk only, no API calls, no DB writes")
    args = parser.parse_args()

    all_chunks: list[Chunk] = []
    for rel_path, meta in DOCUMENT_METADATA.items():
        doc_chunks = build_chunks_for_document(rel_path, meta)
        print(f"{rel_path}: {len(doc_chunks)} chunks")
        all_chunks.extend(doc_chunks)

    total_tokens = sum(c.content_tokens for c in all_chunks)
    print(f"\nTotal: {len(all_chunks)} chunks, {total_tokens} tokens across {len(DOCUMENT_METADATA)} documents")

    if args.dry_run:
        print("\n--dry-run: stopping before embedding/DB writes.")
        for c in all_chunks[:3]:
            print(f"\n--- sample chunk: {c.source_document} #{c.chunk_index} ({c.content_tokens} tok) ---")
            print(f"heading: {c.section_heading}")
            print(c.content[:300] + ("..." if len(c.content) > 300 else ""))
        return

    api_key = os.environ.get("OPENAI_API_KEY")
    db_url = os.environ.get("SUPABASE_DB_URL")
    if not api_key:
        sys.exit("OPENAI_API_KEY not set")
    if not db_url:
        sys.exit("SUPABASE_DB_URL not set")

    client = OpenAI(api_key=api_key)
    conn = psycopg2.connect(db_url)
    conn.autocommit = False

    try:
        with conn.cursor() as cur:
            documents_touched = set(c.source_document for c in all_chunks)
            for doc in documents_touched:
                cur.execute(
                    "DELETE FROM public.compliance_chunks WHERE source_document = %s",
                    (doc,),
                )
            print(f"\nCleared existing rows for {len(documents_touched)} document(s) (idempotent re-run).")

            inserted = 0
            for batch_start in range(0, len(all_chunks), EMBED_BATCH_SIZE):
                batch = all_chunks[batch_start : batch_start + EMBED_BATCH_SIZE]
                embeddings = embed_batch(client, [c.content for c in batch])
                for chunk, embedding in zip(batch, embeddings):
                    cur.execute(
                        """
                        INSERT INTO public.compliance_chunks
                            (organisation_id, source_document, source_category, document_title,
                             section_heading, chunk_index, content, content_tokens,
                             embedding, embedding_model, source_url)
                        VALUES (NULL, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                        """,
                        (
                            chunk.source_document,
                            chunk.source_category,
                            chunk.document_title,
                            chunk.section_heading,
                            chunk.chunk_index,
                            chunk.content,
                            chunk.content_tokens,
                            embedding,
                            EMBEDDING_MODEL,
                            chunk.source_url,
                        ),
                    )
                    inserted += 1
                print(f"  embedded+inserted {inserted}/{len(all_chunks)}")
                time.sleep(1)  # stay well clear of the 40k TPM ceiling

        conn.commit()
        print(f"\nDone. {inserted} chunks embedded and committed.")
    except Exception:
        conn.rollback()
        raise
    finally:
        conn.close()


if __name__ == "__main__":
    main()
