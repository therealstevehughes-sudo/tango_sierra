#!/bin/bash
# Monthly billing price check (2026-10-17). Run by root's crontab at
# 04:00 on the 1st. See tools/functions_live/billing-reprice.ts.
set -a
. /root/tango-sierra/supabase/docker/.env 2>/dev/null
set +a
curl -s -X POST https://api.venurite.com/functions/v1/billing-reprice \
  -H "x-cron-secret: $CERT_EXPIRY_CRON_SECRET" \
  -H "Content-Type: application/json" -d '{}'
echo
