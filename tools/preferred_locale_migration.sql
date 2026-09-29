-- Language preferences (2026-09-29)
-- Adds per-user app display language. Null means "fall back to device/site
-- default." Values are app-supported locale codes such as en, pl, ar.

ALTER TABLE public.users
ADD COLUMN IF NOT EXISTS preferred_locale text;
