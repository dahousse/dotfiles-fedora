#!/bin/bash
# Ajoute le cron auto-sync
(crontab -l 2>/dev/null | grep -v auto-sync
echo "0 * * * * /bin/bash $HOME/dotfiles-fedora/scripts/auto-sync.sh"
) | crontab -
echo "✅ Cron auto-sync ajouté"
