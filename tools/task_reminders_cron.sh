#!/bin/bash
# Mid-shift reminders (2026-10-17): every 5 minutes, ask task-due-reminders
# to push "Due now" / "Overdue" to clocked-in staff. Installed as
# /root/backups/task_reminders_cron.sh.
set -a; source /root/tango-sierra/supabase/docker/.env; set +a
curl -s -X POST https://api.venurite.com/functions/v1/task-due-reminders \
  -H "apikey: $ANON_KEY" -H "x-cron-secret: $CERT_EXPIRY_CRON_SECRET"
echo
