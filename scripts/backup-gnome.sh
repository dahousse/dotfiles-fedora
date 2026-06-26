#!/bin/bash
# backup-gnome.sh — Sauvegarde la config GNOME Shell
# dconf + extensions
# Partie de dotfiles-fedora backup system
# Usage: bash scripts/backup-gnome.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$DOTFILES_DIR/backup/gnome"
mkdir -p "$BACKUP_DIR"

echo "🎨 Backup GNOME Shell..."

# dconf — toutes les préférences GNOME
echo "  → dconf dump..."
dconf dump /org/gnome/ > "$BACKUP_DIR/dconf-settings.ini" 2>/dev/null || true
echo "      $(wc -c < "$BACKUP_DIR/dconf-settings.ini") bytes ($(wc -l < "$BACKUP_DIR/dconf-settings.ini") lignes)"

# Extensions list (avec versions)
echo "  → extensions..."
gnome-extensions list 2>/dev/null > "$BACKUP_DIR/extensions-list.txt" || true
echo "      $(wc -l < "$BACKUP_DIR/extensions-list.txt") extensions"

# Détail des extensions
gnome-extensions info dash-to-dock@micxgx.gmail.com 2>/dev/null > "$BACKUP_DIR/extensions-detail.txt" || true
for ext in $(gnome-extensions list 2>/dev/null); do
  echo "--- $ext ---" >> "$BACKUP_DIR/extensions-detail.txt"
  gnome-extensions info "$ext" 2>/dev/null >> "$BACKUP_DIR/extensions-detail.txt" || true
done
echo "      ✅ extensions-detail.txt"

# Thèmes et icônes (juste les noms)
echo "  → thèmes..."
ls ~/.themes/ 2>/dev/null > "$BACKUP_DIR/themes-list.txt" || true
ls ~/.icons/ 2>/dev/null > "$BACKUP_DIR/icons-list.txt" || true
echo "      themes: $(wc -l < "$BACKUP_DIR/themes-list.txt" 2>/dev/null || echo 0)"
echo "      icons: $(wc -l < "$BACKUP_DIR/icons-list.txt" 2>/dev/null || echo 0)"

echo "✅ Backup GNOME terminé → $BACKUP_DIR"
