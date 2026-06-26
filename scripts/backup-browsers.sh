#!/bin/bash
# backup-browsers.sh — Sauvegarde les configs critiques des navigateurs (Option B)
# Firefox + Chromium : fichiers essentiels seulement
# Partie de dotfiles-fedora backup system
# Usage: bash scripts/backup-browsers.sh

set -e

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
BACKUP_DIR="$DOTFILES_DIR/backup/browsers"
FF_SRC="$HOME/.mozilla/firefox"
CHROMIUM_SRC="$HOME/.config/chromium"
mkdir -p "$BACKUP_DIR"

echo "🌐 Backup navigateurs (Option B — fichiers critiques)..."

# ── Firefox ──────────────────────────────────────
get_ff_profile() {
  # Cherche le profile par défaut dans profiles.ini (format Fedora)
  local ini="$1/profiles.ini"
  local profile_dir=""
  # Méthode 1: section [General] avec Default=1
  local section=$(grep -n '^\[Profile' "$ini" 2>/dev/null | cut -d: -f1)
  while IFS= read -r line; do
    local next_section=$(echo "$section" | grep -A1 "^${line}$" | tail -1)
    local block=$(sed -n "${line},${next_section:-$}p" "$ini" 2>/dev/null | grep -E '^(Default|Path)=')
    local default=$(echo "$block" | grep '^Default=' | cut -d= -f2 | tr -d '[:space:]')
    local path=$(echo "$block" | grep '^Path=' | cut -d= -f2 | tr -d '[:space:]')
    if [ "$default" = "yes" ] || [ "$default" = "1" ]; then
      profile_dir="$path"
      break
    fi
  done <<< "$(echo "$section")"
  [ -n "$profile_dir" ] && echo "$profile_dir" || echo ""
}

FF_PROFILE=$(get_ff_profile "$FF_SRC")
if [ -n "$FF_PROFILE" ] && [ -d "$FF_SRC/$FF_PROFILE" ]; then
  FF_DEST="$BACKUP_DIR/firefox"
  mkdir -p "$FF_DEST"
  echo "  🦊 Firefox profile: $FF_PROFILE"

  for f in places.sqlite logins.json extensions.json prefs.js containers.json key4.db cert9.db; do
    if [ -f "$FF_SRC/$FF_PROFILE/$f" ]; then
      cp "$FF_SRC/$FF_PROFILE/$f" "$FF_DEST/$f"
      echo "      ✅ $f"
    fi
  done

  # Extension list (from addons.json for human readability)
  if [ -f "$FF_SRC/$FF_PROFILE/addons.json" ]; then
    python3 -c "
import json
with open('$FF_SRC/$FF_PROFILE/addons.json') as f:
    data = json.load(f)
for addon in data.get('addons', []):
    if addon.get('type') == 'extension' and addon.get('active', False):
        print(addon.get('defaultLocale', {}).get('name', addon.get('id', 'unknown')))
" > "$FF_DEST/extensions-list.txt" 2>/dev/null || true
    echo "      ✅ extensions-list.txt ($(wc -l < "$FF_DEST/extensions-list.txt") extensions actives)"
  fi

  echo "  🦊 Firefox: $(du -sh "$FF_DEST" | cut -f1) backupé"
else
  echo "  ⚠️  Firefox profile introuvable ($FF_SRC/$FF_PROFILE)"
fi

# ── Chromium ─────────────────────────────────────
if [ -d "$CHROMIUM_SRC/Default" ]; then
  CHR_DEST="$BACKUP_DIR/chromium"
  mkdir -p "$CHR_DEST"
  echo "  🌐 Chromium..."

  for f in Preferences "Login Data" Cookies History "Web Data"; do
    if [ -f "$CHROMIUM_SRC/Default/$f" ]; then
      cp "$CHROMIUM_SRC/Default/$f" "$CHR_DEST/$f" 2>/dev/null || true
      echo "      ✅ $f"
    fi
  done

  # Local State (au root)
  if [ -f "$CHROMIUM_SRC/Local State" ]; then
    cp "$CHROMIUM_SRC/Local State" "$CHR_DEST/Local State" 2>/dev/null || true
    echo "      ✅ Local State"
  fi

  # Extensions (dossier des extensions installées)
  if [ -d "$CHROMIUM_SRC/Default/Extensions" ]; then
    mkdir -p "$CHR_DEST/Extensions"
    cp -r "$CHROMIUM_SRC/Default/Extensions/"* "$CHR_DEST/Extensions/" 2>/dev/null || true
    echo "      ✅ Extensions/ ($(ls "$CHR_DEST/Extensions" 2>/dev/null | wc -l) dossiers)"
  fi

  # Liste des extensions en texte
  ls "$CHROMIUM_SRC/Default/Extensions/" 2>/dev/null > "$CHR_DEST/extensions-ids.txt" || true
  echo "      ✅ extensions-ids.txt"

  echo "  🌐 Chromium: $(du -sh "$CHR_DEST" | cut -f1) backupé"
else
  echo "  ⚠️  Chromium introuvable"
fi

echo "✅ Backup navigateurs terminé → $BACKUP_DIR"
