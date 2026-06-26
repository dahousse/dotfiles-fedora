#!/bin/bash
# setup-watcher.sh — Active le watcher temps réel (systemd --user path unit)
# Usage: bash scripts/setup-watcher.sh

set -e

echo "🚀 Installation du watcher temps réel..."

# Copier les units systemd
mkdir -p "$HOME/.config/systemd/user"
cp "$(dirname "$0")/../systemd/dotfiles-sync.service" "$HOME/.config/systemd/user/"
cp "$(dirname "$0")/../systemd/dotfiles-sync.path" "$HOME/.config/systemd/user/"

# Recharger, activer, démarrer
systemctl --user daemon-reload
systemctl --user enable dotfiles-sync.path
systemctl --user start dotfiles-sync.path

echo "✅ Watcher activé — modifie un dotfile pour tester !"
systemctl --user status dotfiles-sync.path --no-pager 2>&1 | head -4
