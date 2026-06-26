#!/bin/bash
# backup-packages.sh — Sauvegarde les listes de paquets installés
# Partie de dotfiles-fedora backup system
# Usage: bash scripts/backup-packages.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$DOTFILES_DIR/backup/packages"
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
mkdir -p "$BACKUP_DIR"

echo "📦 Backup des packages..."

# dnf — tous les paquets installés (hors groupes)
echo "  → dnf list..."
dnf list --installed 2>/dev/null | tail -n +2 > "$BACKUP_DIR/dnf-full.txt" 2>/dev/null || \
  rpm -qa --queryformat '%{NAME}-%{VERSION}-%{RELEASE}.%{ARCH}\n' > "$BACKUP_DIR/dnf-full.txt"
echo "      $(wc -l < "$BACKUP_DIR/dnf-full.txt") paquets"

# dnf — juste les noms (plus léger pour réinstall)
awk -F. '{print $1}' "$BACKUP_DIR/dnf-full.txt" | sort -u > "$BACKUP_DIR/dnf-names.txt"
echo "      $(wc -l < "$BACKUP_DIR/dnf-names.txt") noms uniques"

# flatpak
echo "  → flatpak list..."
flatpak list --app --columns=application 2>/dev/null > "$BACKUP_DIR/flatpak.txt" || true
echo "      $(wc -l < "$BACKUP_DIR/flatpak.txt") apps"

# pip global
echo "  → pip list..."
pip list --format=freeze 2>/dev/null > "$BACKUP_DIR/pip.txt" || true
echo "      $(wc -l < "$BACKUP_DIR/pip.txt") paquets"

# snap (si présent)
if command -v snap &>/dev/null; then
  snap list 2>/dev/null | tail -n +2 | awk '{print $1}' > "$BACKUP_DIR/snap.txt" || true
fi

echo "✅ Backup packages terminé → $BACKUP_DIR"
