#!/bin/sh
set -eu

if [ "${RUN_MIGRATIONS:-false}" = "true" ]; then
  echo "[entrypoint] running migrations..."
  bundle exec rails db:migrate
fi

echo "[entrypoint] running as $(id -u):$(id -g)"
echo "[entrypoint] Starting app: $*"

exec "$@"
