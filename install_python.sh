#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="${HOME}/dotfiles"
[[ -f "${SCRIPT_DIR}/utils.sh" ]] && source "${SCRIPT_DIR}/utils.sh" || log() { echo "$@"; }

# Default Python version if none specified
PYTHON_VERSION="${PYTHON_VERSION:-3.12.2}"

install_python_dependencies() {
  log "Installing build dependencies for Python..."
  if command -v apt-get &>/dev/null; then
    sudo apt-get update
    sudo apt-get install -y build-essential libssl-dev zlib1g-dev \
      libncurses5-dev libgdbm-dev libnss3-dev libsqlite3-dev \
      libreadline-dev libffi-dev curl libbz2-dev
  elif command -v dnf &>/dev/null; then
    sudo dnf groupinstall -y "Development Tools"
    sudo dnf install -y gcc openssl-devel bzip2-devel libffi-devel \
      zlib-devel readline-devel sqlite-devel
  fi
}

install_python() {
  if command -v python3 &>/dev/null; then
    CURRENT_VER=$(python3 --version | cut -d' ' -f2)
    log "Python is already installed (version: ${CURRENT_VER})"
  fi

  log "Downloading Python ${PYTHON_VERSION} source..."
  TMP_DIR="$(mktemp -d)"
  TAR_FILE="${TMP_DIR}/Python-${PYTHON_VERSION}.tar.xz"
  DOWNLOAD_URL="https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tar.xz"

  curl -sSfL "${DOWNLOAD_URL}" -o "${TAR_FILE}"

  log "Extracting Python archive..."
  tar -xf "${TAR_FILE}" -C "${TMP_DIR}"

  SRC_DIR="${TMP_DIR}/Python-${PYTHON_VERSION}"
  pushd "${SRC_DIR}" > /dev/null

  log "Configuring build with optimizations..."
  ./configure --enable-optimizations --prefix=/usr/local

  log "Compiling Python (using $(nproc) cores)..."
  make -j"$(nproc)"

  log "Installing Python binary..."
  sudo make altinstall

  popd > /dev/null
  rm -rf "${TMP_DIR}"

  log "✔ Python ${PYTHON_VERSION} installation complete! Access it via python3.12"
}

install_python_dependencies
install_python