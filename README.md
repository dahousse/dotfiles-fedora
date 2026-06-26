# 🖥️ dotfiles-fedora

> Mes dotfiles Fedora 44 — synchronisés automatiquement sur GitHub en **temps réel**.
> Backup complet du système (packages, navigateurs, configs) + restauration Ansible post-crash.

## 📦 Structure

```
~/dotfiles-fedora/
├── backup/                 # Données backupées (navigateurs exclus du git)
│   ├── packages/           # dnf + flatpak + pip lists
│   ├── browsers/           # Firefox + Chromium (Option B, fichiers critiques)
│   ├── gnome/              # dconf + extensions
│   └── vscode/             # settings + extensions
├── docs/
│   └── restore-notes.md    # Procédure de restauration post-crash
├── git/.gitconfig          # → ~/.gitconfig (symlink)
├── shell/.p10k.zsh         # → ~/.p10k.zsh (symlink)
├── zsh/.zshrc              # → ~/.zshrc (symlink)
├── install.sh              # Installe les symlinks sur un PC neuf
├── scripts/
│   ├── backup-all.sh       # Orchestrateur — lance toutes les sauvegardes
│   ├── backup-packages.sh  # dnf (4232) + flatpak (54) + pip (401)
│   ├── backup-browsers.sh  # Firefox + Chromium (Option B)
│   ├── backup-gnome.sh     # dconf + extensions
│   ├── backup-vscode.sh    # settings + extensions
│   ├── auto-sync.sh        # Push vers GitHub (appelé par le watcher)
│   ├── setup-watcher.sh    # Active le watcher en 1 commande
│   └── setup-cron.sh       # Fallback cron si pas de systemd
├── systemd/
│   ├── dotfiles-sync.path     # Watcher temps réel (le graal)
│   ├── dotfiles-sync.service  # Commit + push automatique
│   ├── dotfiles-backup.timer  # Backup quotidien ~minuit
│   └── dotfiles-backup.service
└── logs/
```

## ⚙️ Comment ça marche

### 🔥 Watcher temps réel (le Graal)

1. **Symlinks** : `.zshrc` → `~/dotfiles-fedora/zsh/.zshrc` (modification directe dans le repo)
2. **systemd path unit** surveille les dotfiles + backup en temps réel
3. Dès que tu sauvegardes une modif → **commit + push automatique en < 2 secondes**
4. Zéro action manuelle

```bash
# Vérifier que le graal tourne
systemctl --user status dotfiles-sync.path
```

### ⏰ Backup quotidien complet

Timer systemd qui lance `backup-all.sh` tous les jours vers minuit :

```bash
systemctl --user status dotfiles-backup.timer
```

### 🖐️ Backup manuel

```bash
~/dotfiles-fedora/scripts/backup-all.sh
```

## 📋 Scripts de backup

| Script | Sauvegarde | Contenu |
|--------|-----------|---------|
| `backup-packages.sh` | `backup/packages/` | dnf (4000+), flatpak (54), pip (401) |
| `backup-browsers.sh` | `backup/browsers/` | Firefox + Chromium — fichiers critiques (Option B) |
| `backup-gnome.sh` | `backup/gnome/` | dconf complet + 50 extensions GNOME |
| `backup-vscode.sh` | `backup/vscode/` | settings.json + 74 extensions |
| `backup-all.sh` | Tout | Orchestrateur — lance les 4 ci-dessus |

> 🔒 Les données navigateurs (`backup/browsers/`) sont exclues du git — jamais pushées sur GitHub.

## 🚀 Restauration post-crash

### Sur le PC neuf

```bash
git clone https://github.com/dahousse/dotfiles-fedora.git
cd dotfiles-fedora
bash install.sh
```

### Restauration complète (depuis la VM infra)

```bash
ssh infra@192.168.1.3
cd /home/infra/ansible-infra-lab2
ansible-playbook playbook_restore_laptop.yml -i inventory
```

Ce playbook **restaure tout** : dotfiles → packages (dnf/flatpak/pip) → Firefox → Chromium → GNOME → VS Code.

📄 Voir `docs/restore-notes.md` pour le détail complet.

## 💾 Niveaux de sauvegarde

| Niveau | Quoi | Quand |
|:---|---:|:---|
| 🔥 Instantané | systemd path unit (watcher) | Dès qu'un fichier est modifié |
| ⏰ Quotidien | `dotfiles-backup.timer` | Tous les jours vers minuit |
| 🖐️ Manuel | `backup-all.sh` | Quand tu veux |

## 📜 Changelog

| Version | Date | Changements |
|:---|---:|:---|
| v0.8.0 | 2026-06-26 | Backup auto + Option B navigateurs + Ansible restore |
| v0.7.0 | – | Watcher temps réel + sync automatique |
| v0.6.0 | – | Structure symlinks + install.sh |
| v0.5.0 | – | Version initiale dotfiles |

---

*Fedora 44 — Hasmi — [dotfiles-fedora](https://github.com/dahousse/dotfiles-fedora)*
