#!/bin/bash

set -e

DOTFILES_DIR="$(pwd)"

echo "🚀 Installing dotfiles..."

# -------------------
# ZSH
# -------------------
echo "🔧 setting zsh config"
ln -sf $DOTFILES_DIR/zsh/.zshrc $HOME/.zshrc

# -------------------
# P10K
# -------------------
echo "🎨 setting p10k"
ln -sf $DOTFILES_DIR/shell/.p10k.zsh $HOME/.p10k.zsh

# -------------------
# GIT
# -------------------
echo "📦 setting git config"
ln -sf $DOTFILES_DIR/git/.gitconfig $HOME/.gitconfig

# -------------------
# AI CLI GLOBAL
# -------------------
echo "🤖 setting ai CLI"
mkdir -p $HOME/.local/bin
ln -sf $HOME/infra-lab2/tools/ai-cli-v2/ai $HOME/.local/bin/ai

# -------------------
# PATH FIX (zsh safe)
# -------------------
if ! grep -q ".local/bin" $HOME/.zshrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> $HOME/.zshrc
fi

echo "✅ Dotfiles installed successfully"
echo "👉 restart shell or run: source ~/.zshrc"
