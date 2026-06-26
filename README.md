# 🖥️ dotfiles-fedora

> Mes dotfiles Fedora 44 — synchronisés automatiquement sur GitHub.

## 📦 Structure

```
~/dotfiles-fedora/
├── git/.gitconfig        # → ~/.gitconfig (symlink)
├── shell/.p10k.zsh       # → ~/.p10k.zsh (symlink)
├── zsh/.zshrc            # → ~/.zshrc (symlink)
├── install.sh            # Installe les symlinks sur un PC neuf
├── scripts/auto-sync.sh  # Push auto vers GitHub (cron @hourly)
├── scripts/setup-cron.sh # Ajoute le cron en 1 commande
├── logs/                 # Logs du cron
└── backups/              # Backups des dotfiles originaux
```

## ⚙️ Comment ça marche

1. Les dotfiles sont en **symlinks** vers ce repo
2. Tu modifies `~/.zshrc` → tu modifies directement le repo
3. **Cron toutes les heures** : `auto-sync.sh` commit + push vers GitHub
4. **Pas d'action manuelle** — ça bosse tout seul

## 🚀 Restauration (PC neuf / après panne)

```bash
# 1. Cloner
git clone https://github.com/dahousse/dotfiles-fedora.git
cd dotfiles-fedora

# 2. Installer
bash install.sh

# 3. Activer le cron auto
bash scripts/setup-cron.sh

# 4. Source
source ~/.zshrc
```

## 🔄 Forcer un sync manuel

```bash
cd ~/dotfiles-fedora && bash scripts/auto-sync.sh
```

## 💾 Backup automatique

| Fréquence | Mécanisme |
|:---|---|
| Toutes les heures | Cron system → `scripts/auto-sync.sh` |
| Au changement | Via symlink direct — modification en temps réel |

---

*Fedora 44 — Hasmi*
