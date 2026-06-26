#!/bin/bash
# backup-vscode.sh — Sauvegarde la config VS Code
# settings + keybindings + extensions
# Partie de dotfiles-fedora backup system
# Usage: bash scripts/backup-vscode.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$DOTFILES_DIR/backup/vscode"
VSCODE_USER="$HOME/.config/Code/User"
mkdir -p "$BACKUP_DIR"

echo "💻 Backup VS Code..."

# Settings
if [ -f "$VSCODE_USER/settings.json" ]; then
  cp "$VSCODE_USER/settings.json" "$BACKUP_DIR/settings.json"
  echo "  ✅ settings.json ($(wc -c < "$BACKUP_DIR/settings.json") bytes)"
fi

if [ -f "$VSCODE_USER/keybindings.json" ]; then
  cp "$VSCODE_USER/keybindings.json" "$BACKUP_DIR/keybindings.json"
  echo "  ✅ keybindings.json"
fi

# Extensions list
if command -v code &>/dev/null; then
  code --list-extensions --show-versions 2>/dev/null > "$BACKUP_DIR/extensions.txt" || true
  echo "  ✅ extensions.txt ($(wc -l < "$BACKUP_DIR/extensions.txt") extensions)"
fi

# Snippets (si existent)
if [ -d "$VSCODE_USER/snippets" ]; then
  mkdir -p "$BACKUP_DIR/snippets"
  cp -r "$VSCODE_USER/snippets/"* "$BACKUP_DIR/snippets/" 2>/dev/null || true
  echo "  ✅ snippets/"
fi

echo "✅ Backup VS Code terminé → $BACKUP_DIR"
