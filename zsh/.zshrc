# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
export PATH="$HOME/.local/bin:$PATH"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(
git
docker
docker-compose
systemd
fzf
zoxide
zsh-autosuggestions
zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# ---------- ALIASES ----------

alias ll='eza -lh --icons'
alias la='eza -lha --icons'
alias cat='bat'
alias cls='clear'

alias dps='docker ps'
alias dpa='docker ps -a'
alias dstop='docker stop $(docker ps -q)'
alias drm='docker rm $(docker ps -aq)'

#alias ai='wollama'
alias explain='wollama'
alias fix='wollama "fix this linux issue:"'
alias dockerfix='wollama "fix this docker issue:"'
alias sys='wollama "analyze my linux system"'
alias ram='free -h'
alias cpu='btop'
# ---------- ZOXIDE ----------

eval "$(zoxide init zsh)"

# ---------- HISTORY ----------

HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

setopt SHARE_HISTORY
setopt HIST_IGNORE_DUPS
setopt AUTO_CD

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
# ---------- STARTUP ----------
fastfetch

