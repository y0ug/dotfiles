load_env() {
  local env_file="$HOME/.config/env/$1.sops.env"

  if [[ ! -f "$env_file" ]]; then
    echo "❌ Error: Environment file '$env_file' not found!"
    return 1
  fi

  set -a
  eval "$(sops -d "${env_file}" | sed 's/^export //')"
  set +a
  export SOPS_ENV_LOADED="$env_file"

  # echo "✅ Loaded environment from $env_file"
}
load_env "$1"
