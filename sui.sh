#!/usr/bin/env bash
set -e

DEST_DIR="./my-devcontainer-dotfiles"

echo "Creating dotfile directory at ${DEST_DIR}..."
mkdir -p "${DEST_DIR}/zsh"

# Copy main config files
if [ -f "$HOME/.zshrc" ]; then
    cp "$HOME/.zshrc" "${DEST_DIR}/zsh/.zshrc"
    echo "Copied .zshrc"
fi

if [ -f "$HOME/.p10k.zsh" ]; then
    cp "$HOME/.p10k.zsh" "${DEST_DIR}/zsh/.p10k.zsh"
    echo "Copied .p10k.zsh"
fi

# Copy custom plugins/themes if present in Oh My Zsh
OMZ_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$OMZ_CUSTOM" ]; then
    mkdir -p "${DEST_DIR}/zsh/custom"
    echo "Copying custom plugins and themes..."
    rsync -av --exclude='.git' "$OMZ_CUSTOM/" "${DEST_DIR}/zsh/custom/" 2>/dev/null || cp -r "$OMZ_CUSTOM/"* "${DEST_DIR}/zsh/custom/" 2>/dev/null || true
fi

echo "Done! Your dotfiles folder is prepared at ${DEST_DIR}"