./custom_pok_install.sh

cp ./utils.sh ~/
./install_eza.sh
./install_jq.sh

#!/usr/bin/env bash
set -e

# Target user directory
TARGET_HOME="${HOME}"
DOTFILES_DIR="${HOME}/dotfiles"

echo "Installing Zsh dotfiles for non-root user in ${TARGET_HOME}..."

# 1. Install Oh My Zsh locally if it doesn't exist (Unattended mode)
if [ ! -d "${TARGET_HOME}/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh without root..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# 2. Copy .zshrc and related files
if [ -f "${DOTFILES_DIR}/zsh/.zshrc" ]; then
    cp "${DOTFILES_DIR}/zsh/.zshrc" "${TARGET_HOME}/.zshrc"
    echo "Linked .zshrc"
fi

if [ -f "${DOTFILES_DIR}/zsh/.p10k.zsh" ]; then
    cp "${DOTFILES_DIR}/zsh/.p10k.zsh" "${TARGET_HOME}/.p10k.zsh"
    echo "Linked .p10k.zsh"
fi

# 3. Restore custom plugins/themes
if [ -d "${DOTFILES_DIR}/zsh/custom" ]; then
    mkdir -p "${TARGET_HOME}/.oh-my-zsh/custom"
    cp -r "${DOTFILES_DIR}/oh-my-zsh/custom/"* "${TARGET_HOME}/.oh-my-zsh/custom/" 2>/dev/null || true
    echo "Restored custom plugins & themes"
fi

# 4. Clone high-frequency plugins directly into user space (Fallback if missing)
PLUGINS_DIR="${TARGET_HOME}/.oh-my-zsh/custom/plugins"
mkdir -p "$PLUGINS_DIR"

if [ ! -d "${PLUGINS_DIR}/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "${PLUGINS_DIR}/zsh-autosuggestions" 2>/dev/null || true
fi

if [ ! -d "${PLUGINS_DIR}/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "${PLUGINS_DIR}/zsh-syntax-highlighting" 2>/dev/null || true
fi

echo "Dotfiles successfully installed!"

cp ./.p10k.zsh "${HOME}"
cp ./.zshrc "${HOME}"