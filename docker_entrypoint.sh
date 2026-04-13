#!/bin/sh
set -eu

export_app_service_env() {
  profile_d=/etc/profile.d
  profile_script="${profile_d}/00-app-service-env.sh"

  mkdir -p "${profile_d}"
  : > "${profile_script}"

  printenv | while IFS='=' read -r name value; do
    case "${name}" in
      PWD|SHLVL|_|OLDPWD)
        continue
        ;;
    esac

    escaped_value=$(printf "%s" "${value}" | sed 's/[\\"]/\\&/g')
    printf 'export %s="%s"\n' "${name}" "${escaped_value}" >> "${profile_script}"
  done

  chmod 0644 "${profile_script}"
}

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
  export_app_service_env
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
