#!/bin/bash
# auto-sync.sh — Push auto des dotfiles vers GitHub
# Lancé par cron toutes les heures

REPO_DIR="$HOME/dotfiles-fedora"
LOG_FILE="$REPO_DIR/logs/auto-sync.log"
mkdir -p "$REPO_DIR/logs"

cd "$REPO_DIR" || exit 1

# Vérifier s'il y a des changements
if [[ -z "$(git status --porcelain)" ]]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Rien à synchroniser" >> "$LOG_FILE"
    exit 0
fi

# Afficher les changements dans le log
echo "[$(date '+%Y-%m-%d %H:%M:%S')] Changements détectés :" >> "$LOG_FILE"
git status --porcelain >> "$LOG_FILE"

# Add, commit, push
git add -A
git commit -m "auto-sync: $(date '+%Y-%m-%d %H:%M:%S')"
git push origin main 2>> "$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ✅ Push réussi" >> "$LOG_FILE"
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ❌ Échec du push" >> "$LOG_FILE"
fi

# Nettoyer les logs (garder les 100 dernières lignes)
tail -n 100 "$LOG_FILE" > "$LOG_FILE.tmp" && mv "$LOG_FILE.tmp" "$LOG_FILE"
