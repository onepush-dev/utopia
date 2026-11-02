#!/bin/bash
# Railway start wrapper for Utopia.
set -e
# Listen on Railway's PORT unless UTOPIA_BIND_ADDR is set explicitly.
if [ -z "${UTOPIA_BIND_ADDR:-}" ]; then
  export UTOPIA_BIND_ADDR="0.0.0.0:${PORT:-1516}"
fi
mkdir -p "${UTOPIA_DATA_DIR:-/app/data}"
# Wait up to 180 s for Postgres so first-boot migrations never race the database.
if [ -n "${UTOPIA_DATABASE_URL:-}" ]; then
  hostport=$(echo "$UTOPIA_DATABASE_URL" | sed -E 's#^[a-z]+://[^@]*@([^/?]+).*#\1#')
  host=${hostport%:*}; port=${hostport##*:}; [ "$port" = "$hostport" ] && port=5432
  host=$(echo "$host" | tr -d '[]')
  i=0
  while [ $i -lt 90 ]; do
    if (exec 3<>"/dev/tcp/$host/$port") 2>/dev/null; then break; fi
    i=$((i+1)); echo "waiting for Postgres at $host:$port ($i)"; sleep 2
  done
fi
exec "$@"
