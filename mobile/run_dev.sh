#!/bin/bash
set -e

# Load .env.local into environment
if [ -f .env.local ]; then
  set -a
  source .env.local
  set +a
else
  echo "Error: .env.local not found"
  exit 1
fi

flutter run \
  --target lib/main_dev.dart \
  --no-enable-impeller \
  --dart-define=SUPABASE_URL="$SUPABASE_URL" \
  --dart-define=SUPABASE_ANON_KEY="$SUPABASE_ANON_KEY" \
  "$@"
