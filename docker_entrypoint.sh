#!/bin/sh
set -eu

run_as_rails() {
  if [ "$(id -u)" -eq 0 ]; then
    exec gosu rails "$@"
  else
    exec "$@"
  fi
}

if [ "${ENABLE_APP_SERVICE_SSH:-false}" = "true" ]; then
  if [ "$(id -u)" -ne 0 ]; then
    echo "[entrypoint] ENABLE_APP_SERVICE_SSH=true requires the container to start as root" >&2
    exit 1
  fi

  echo "[entrypoint] enabling App Service SSH on port 2222"
  mkdir -p /run/sshd
  ssh-keygen -A
  echo 'root:Docker!' | chpasswd
  /usr/sbin/sshd
fi

if [ "${RUN_MIGRATIONS:-false}" = "true" ]; then
  echo "[entrypoint] running migrations..."
  if [ "$(id -u)" -eq 0 ]; then
    gosu rails bundle exec rails db:migrate
  else
    bundle exec rails db:migrate
  fi
fi

echo "[entrypoint] running as $(id -u):$(id -g)"
echo "[entrypoint] Starting app: $*"

run_as_rails "$@"
