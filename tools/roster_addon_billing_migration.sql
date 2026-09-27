-- Roster add-on real billing (2026-09-27) — tracks the add-on's own,
-- separate GoCardless subscription (distinct from the main plan's
-- subscriptions.provider_subscription_id) so it can be looked up and
-- cancelled independently when the toggle is switched off.
alter table subscriptions add column if not exists roster_addon_gc_subscription_id text;
