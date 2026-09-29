-- AI assistant locale-aware cache migration.
--
-- Apply on the Supabase/Postgres host before deploying the updated
-- tools/ai-assistant_index.ts function. Then restart/reload PostgREST so the
-- updated RPC signature is visible to Edge Functions.

alter table public.ai_answer_cache
  add column if not exists response_locale text not null default 'en',
  add column if not exists response_language text not null default 'English';

create index if not exists ai_answer_cache_response_locale_idx
  on public.ai_answer_cache (response_locale);

drop function if exists public.match_ai_answer_cache(vector, double precision);
drop function if exists public.match_ai_answer_cache(vector, double precision, text);

create or replace function public.match_ai_answer_cache(
  query_embedding vector(1536),
  match_threshold double precision,
  response_locale_filter text default 'en'
)
returns table (
  id bigint,
  answer_text text,
  citation_document text,
  citation_url text,
  hit_count integer,
  similarity double precision
)
language sql
stable
security definer
set search_path = public
as $$
  select
    c.id,
    c.answer_text,
    c.citation_document,
    c.citation_url,
    c.hit_count,
    1 - (c.question_embedding <=> query_embedding) as similarity
  from public.ai_answer_cache c
  where c.response_locale = coalesce(nullif(response_locale_filter, ''), 'en')
    and 1 - (c.question_embedding <=> query_embedding) >= match_threshold
  order by c.question_embedding <=> query_embedding
  limit 1;
$$;
