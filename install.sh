#!/usr/bin/env bash
set -euo pipefail
log() { printf "%s [install-app] %s\n" "$(date '+%F %T')" "$*"; }

search_for_uv() {
  uv_bin_path=""
  local expected_uv_paths=(
    "$HOME/.cargo/bin/uv"
    "${XDG_BIN_HOME:-$HOME/.local/bin}/uv"
  )
  for bin_path in "${expected_uv_paths[@]}"; do
    if [ -f "$bin_path" ]; then
      uv_bin_path="$bin_path"
      break
    fi
  done
}

install_app_with_uv() {
  local app_name="$1"
  if [[ -x "$uv_bin_path" ]]; then
    log "uv found in '${uv_bin_path}'."
    log "Attempting to install $app_name"
    "$uv_bin_path" -n tool install "$app_name"
    log "$app_name is successfully installed."
    exit 0
  else
    log "uv found in '${uv_bin_path}'. But it is not executable! \
$app_name cannot be installed."
    exit 1
  fi
}

main() {
  if [ -z "${1:-}" ]; then
    log "Error: An app name (PyPI package name) must be provided."
    echo "Usage: $0 <app-name>"
    exit 1
  fi
  local app_name="$1"
  search_for_uv

  if [ -n "$uv_bin_path" ]; then
    install_app_with_uv "$app_name"
  else
    log() { printf '%s [install-uv] %s\n' "$(date '+%F %T')" "$*"; }
    # See documentation: https://docs.astral.sh/uv/getting-started/installation/
    log "Attempting to install uv."
    if command -v curl >/dev/null 2>&1; then
      curl -LsSf https://astral.sh/uv/install.sh | sh
    elif command -v wget >/dev/null 2>&1; then
      wget -qO- https://astral.sh/uv/install.sh | sh
    else
      log "Neither curl or wget was found. uv could not be installed!" && exit 1
    fi
  fi
  search_for_uv
  install_app_with_uv "$app_name"
}

main "$@"
