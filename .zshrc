# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#!/usr/bin/env zsh

autoload -Uz zmv
autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

# Finally, make sure the terminal is in application mode, when zle is
# active. Only then are the values from $terminfo valid.
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )); then
  function zle-line-init () {
    echoti smkx
  }
  function zle-line-finish () {
    echoti rmkx
  }
  zle -N zle-line-init
  zle -N zle-line-finish
fi
## Key bindings
bindkey -e

# / is not a part of word, allows ctrl+w to delete paths up till /
WORDCHARS=''

source /usr/share/doc/find-the-command/ftc.zsh

# History settings
HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=10000
setopt inc_append_history
setopt extended_history
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_no_functions
unsetopt hist_verify

# MISC zsh settings
setopt auto_cd
setopt multios
unsetopt correctall

# Named directories
dotfiles=~/git/dotfiles
charon=~/git/src/github.com/ygt/charon
spin=~/git/spin
frontend=~/git/frontend
puppet=~/git/puppet
sales=~/git/sales
spabreaks=~/git/spabreaks
qs=~/git/sb-query-server
redemptions=~/git/sb-voucher-redemptions
canting=~/git/canting
media=/home/media
# : ~dotfiles ~charon ~spin ~frontend ~puppet ~redemptions ~sales ~spabreaks ~media ~canting

# Prompts
autoload -Uz colors && colors
autoload -Uz vcs_info
setopt prompt_subst

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked
zstyle ':vcs_info:git*' formats "%{$reset_color%} at %{$fg[blue]%}%b%{$reset_color%} %{$fg[green]%}%c%u"

function +vi-git-untracked() {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
    git status --porcelain | grep '??' &> /dev/null ; then hook_com[unstaged]+="+"
  fi
}

precmd() {
  vcs_info
}

export PROMPT='%B%(?..[%?] )%b%n@%U%m%u in %{$fg[yellow]%}%1~${vcs_info_msg_0_}%{$reset_color%}> '
export RPROMPT="%F{yellow}%~%f"

# PATH
typeset -U path
path=(~/.node_modules/bin
      /usr/bin/vendor_perl
      ~/.rbenv/bin
      ~/scripts
      ~/.local/bin
      $path)

# Export section
export EDITOR=nvim
export SHELL=/bin/zsh
# export PAGER=nvimpager
export GOPATH=~/git
export RUBY_GC_MALLOC_LIMIT=90000000
export RUBY_GC_HEAP_FREE_SLOTS=200000
# export FZF_DEAFULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix'
export COMPOSE_DOCKER_CLI_BUILD=1
export DOCKER_BUILDKIT=1
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
export MOZ_ENABLE_WAYLAND=1

# Start qiv with: fulscreen, atorotate, scaling large images down and no status bar.
alias qiv='qiv -f -l -t -i $1'

# Keychain activation.
eval $(keychain --inherit any-once --eval --quiet --noask id_ed25519)

# Initialize rbenv
eval "$(rbenv init -)"

# Aliases for different ls commands
alias ls='ls --color=auto'
alias ll='ls -l'
alias l='exa -ahl'

# Some aliases
# alias sudo='sudo -E'
alias vi=vim
alias md='mkdir -p'

alias psack='ps aux | rg $1'
alias expack='export | rg $1'
alias lack='l | rg $1'
alias nara="sudo shutdown -hP now"
alias vim=nvim
alias task=go-task

# Git aliases
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit -v'
alias gco='git checkout'
alias gd='git diff'
alias gdca='git diff --cached'
alias gdne='git diff --no-ext-diff'
alias gl='git pull'
alias glog='git log --oneline --decorate --graph'
alias gp='git push -u'
function grec() {
  git branch --sort=-committerdate | head -n "${1:-10}"
}
alias grhh="git reset --hard HEAD"
alias gst='git status'
alias gsta='git stash save'
alias gstp='git stash pop'
function github_pr_title() {
  IFS=- read jira1 jira2 branch <<< "$(git symbolic-ref --short HEAD)"
  echo "[${jira1}-${jira2}] $(echo $branch | tr '-' ' ')"
} 

alias rs='bin/rails s'
alias rc='bin/rails c'

alias dco='docker-compose'

alias nvm-init='source /usr/share/nvm/init-nvm.sh && nvm use'

alias k='kubectl'

function mkcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

function docker-clean {
  docker rm -v $(docker ps --filter status=exited -q 2>/dev/null) 2>/dev/null
  docker rmi $(docker images --filter dangling=true -q 2>/dev/null) 2>/dev/null
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f ~/k/k.sh ] && source ~/k/k.sh

# added by travis gem
[ -f /home/gat/.travis/travis.sh ] && source /home/gat/.travis/travis.sh

source '/usr/share/zsh/site-functions/_gcloud'
# The next line updates PATH for the Google Cloud SDK.
if [ -f /home/gat/git/spabreaks/google-cloud-sdk/path.zsh.inc ]; then
  source '/home/gat/git/spabreaks/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /home/gat/git/spabreaks/google-cloud-sdk/completion.zsh.inc ]; then
  source '/home/gat/git/spabreaks/google-cloud-sdk/completion.zsh.inc'
fi

# Source pazi
if command -v pazi &>/dev/null; then
  eval "$(pazi init zsh)"
fi

export PATH="$HOME/.yarn/bin:$PATH"
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
