# Restauration Post-Crash — Fedora 44 Laptop

## Procédure de restauration complète

Après un crash, voici comment remettre le laptop exactement comme avant.

### Prérequis
- Fedora 44 installé (minimum)
- Accès Internet
- SSH activé (pour lancer Ansible depuis la VM infra)

### Étape 1 : Installer les bases
```bash
sudo dnf install -y git ansible-core
```

### Étape 2 : Cloner dotfiles-fedora
```bash
git clone https://github.com/dahousse/dotfiles-fedora.git ~/dotfiles-fedora
cd ~/dotfiles-fedora
```

### Étape 3 : Lancer la restauration Ansible (depuis la VM infra)
```bash
# Sur la VM infra (192.168.1.3) :
cd /home/infra/ansible-infra-lab2
ansible-playbook playbook_restore_laptop.yml -i inventory
```

### Ce qui est restauré
| Étape | Composant | Fait par |
|-------|-----------|----------|
| 1 | Dotfiles (.zshrc, .p10k, .gitconfig) | Rôle `dotfiles` |
| 2 | Watcher temps réel (systemd path unit) | Rôle `dotfiles` |
| 3 | Paquets dnf (4000+) | Rôle `laptop-restore` |
| 4 | Flatpaks (54) | Rôle `laptop-restore` |
| 5 | Paquets Python (400) | Rôle `laptop-restore` |
| 6 | Firefox — profils, marque-pages, mots de passe | Rôle `laptop-restore` |
| 7 | Chromium — historique, cookies, extensions | Rôle `laptop-restore` |
| 8 | GNOME Shell — dconf, extensions | Rôle `laptop-restore` |
| 9 | VS Code — settings, extensions | Rôle `laptop-restore` |

### Maintenance quotidienne
Les backups sont automatiques :
- **Watcher temps réel** : dès qu'un dotfile change → commit + push GitHub
- **Backup quotidien** : `systemctl --user status dotfiles-backup.timer` (lance backup-all.sh)
- **Manuel** : `bash ~/dotfiles-fedora/scripts/backup-all.sh`

### Vérifier que le watcher tourne
```bash
systemctl --user status dotfiles-sync.path
```

### Structure des backups
```
~/dotfiles-fedora/backup/
├── packages/
│   ├── dnf-full.txt      # Tous les paquets dnf (version complète)
│   ├── dnf-names.txt     # Juste les noms (pour réinstall)
│   ├── flatpak.txt       # Flatpaks
│   └── pip.txt           # Python packages
├── browsers/
│   ├── firefox/          # Fichiers critiques Firefox (Option B)
│   └── chromium/         # Fichiers critiques Chromium (Option B)
├── gnome/
│   ├── dconf-settings.ini    # Toute la config GNOME
│   ├── extensions-list.txt   # Extensions GNOME
│   └── ...
└── vscode/
    ├── settings.json     # VS Code settings
    └── extensions.txt    # Liste des extensions
```
