# 🖥️ dotfiles-fedora

> Mes dotfiles Fedora 44 — synchronisés automatiquement sur GitHub en **temps réel**.

## 📦 Structure

```
~/dotfiles-fedora/
├── git/.gitconfig        # → ~/.gitconfig (symlink)
├── shell/.p10k.zsh       # → ~/.p10k.zsh (symlink)
├── zsh/.zshrc            # → ~/.zshrc (symlink)
├── install.sh            # Installe les symlinks sur un PC neuf
├── scripts/
│   ├── auto-sync.sh      # Push vers GitHub (appelé par le watcher)
│   ├── setup-watcher.sh  # Active le watcher en 1 commande
│   └── setup-cron.sh     # Fallback cron si pas de systemd
├── systemd/              # Units systemd --user du watcher
│   ├── dotfiles-sync.service
│   └── dotfiles-sync.path
├── logs/                 # Logs de synchronisation
└── backups/              # Backups des dotfiles originaux
```

## ⚙️ Comment ça marche

### 🔥 Watcher temps réel (le Graal)

1. **Symlinks** : `.zshrc` → `~/dotfiles-fedora/zsh/.zshrc` (modification directe dans le repo)
2. **systemd path unit** surveille les 3 fichiers
3. Dès que tu sauvegardes une modif → **commit + push automatique en < 2 secondes**
4. Zéro action manuelle

### 🛡️ Cron de sécurité (fallback)

Une sauvegarde toutes les heures au cas où le watcher aurait raté un événement.

## 🚀 Restauration (PC neuf / après panne)

```bash
# 1. Cloner
git clone https://github.com/dahousse/dotfiles-fedora.git
cd dotfiles-fedora

# 2. Installer les symlinks
bash install.sh

# 3. Activer le watcher temps réel (optionnel mais recommandé)
bash scripts/setup-watcher.sh

# 4. Recharger le shell
source ~/.zshrc
```

## 🔄 Forcer un sync manuel

```bash
~/dotfiles-fedora/scripts/auto-sync.sh
```

## 💾 Niveaux de sauvegarde

| Niveau | Quoi | Déclencheur |
|:---|---:|:---|
| 🔥 Instantané | systemd path unit | Sauvegarde d'un fichier |
| ⏱️ Horaire | Cron | Toutes les heures (sécurité) |
| 🖐️ Manuel | `auto-sync.sh` | Quand tu veux |

## 🧠 Pourquoi systemd plutôt qu'incron ?

- **Zéro package** à installer (déjà dans Fedora)
- **Pas de root** nécessaire (units --user)
- **Pas de boucle** : git push ne modifie pas les dotfiles
- **Lock implicite** : les appels sont sérialisés par systemd

---

*Fedora 44 — Hasmi*
