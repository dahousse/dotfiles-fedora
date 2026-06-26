#!/bin/bash
# backup-all.sh — Orchestrateur : lance toutes les sauvegardes
# À exécuter via cron (quotidien) ou manuellement
# Partie de dotfiles-fedora backup system
# Usage: bash scripts/backup-all.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
LOG_DIR="$DOTFILES_DIR/logs"
mkdir -p "$LOG_DIR"

TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')
LOGFILE="$LOG_DIR/backup-$(date '+%Y%m%d').log"

{
  echo "═══════════════════════════════════════════"
  echo "📋 Backup complet — $TIMESTAMP"
  echo "═══════════════════════════════════════════"

  echo ""
  echo "=== 1/4 Packages ==="
  bash "$DOTFILES_DIR/scripts/backup-packages.sh" 2>&1

  echo ""
  echo "=== 2/4 Navigateurs ==="
  bash "$DOTFILES_DIR/scripts/backup-browsers.sh" 2>&1

  echo ""
  echo "=== 3/4 GNOME ==="
  bash "$DOTFILES_DIR/scripts/backup-gnome.sh" 2>&1

  echo ""
  echo "=== 4/4 VS Code ==="
  bash "$DOTFILES_DIR/scripts/backup-vscode.sh" 2>&1

  echo ""
  echo "═══════════════════════════════════════════"
  echo "✅ Backup complet terminé"
  echo "═══════════════════════════════════════════"
} 2>&1 | tee -a "$LOGFILE"

# Auto-sync si les fichiers ont changé
bash "$DOTFILES_DIR/scripts/auto-sync.sh" 2>/dev/null || true
