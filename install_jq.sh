#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="${HOME}/dotfiles"
source "${SCRIPT_DIR}/utils.sh"
source "${SCRIPT_DIR}/detect-os.sh"

install_jq() {
  if command -v jq > /dev/null; then
    log "jq already installed"
    return
  fi

  log "Installing jq from pre-built binary..."

  ARCH=$(uname -m)
  case "${ARCH}" in
    x86_64)
      JQ_ARCH="amd64"
      ;;
    aarch64|arm64)
      JQ_ARCH="arm64"
      ;;
    i386|i686)
      JQ_ARCH="i386"
      ;;
    *)
      warn "Unknown architecture ${ARCH}, defaulting to amd64"
      JQ_ARCH="amd64"
      ;;
  esac

  JQ_API_URL="https://api.github.com/repos/jqlang/jq/releases/latest"
  ASSET_URL=$(curl -sSfL "${JQ_API_URL}" | grep browser_download_url | grep "linux-${JQ_ARCH}" | head -n1 | cut -d '"' -f4)

  if [[ -z "${ASSET_URL}" ]]; then
    warn "Could not resolve latest jq release via API. Falling back to v1.7.1."
    JQ_VERSION="jq-1.7.1"
    ASSET_URL="https://github.com/jqlang/jq/releases/download/${JQ_VERSION}/jq-linux-${JQ_ARCH}"
  else
    JQ_VERSION=$(echo "${ASSET_URL}" | grep -oP 'download/\K[^/]+' || echo "unknown")
  fi

  TMP_DIR="$(mktemp -d)"
  curl -sSfL "${ASSET_URL}" -o "${TMP_DIR}/jq"
  
  auto_sudo mv "${TMP_DIR}/jq" /usr/local/bin/jq
  auto_sudo chmod +x /usr/local/bin/jq
  rm -rf "${TMP_DIR}"

  log "✔ jq installed from pre-built binary (${JQ_VERSION}, linux-${JQ_ARCH})"
}

install_jq