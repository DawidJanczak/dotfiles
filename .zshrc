#!/usr/bin/env zsh

autoload -Uz zmv
autoload -Uz compinit && compinit

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z-_}={A-Za-z_-}' 'r:|=*' 'l:|=* r:|=*'

autoload -U select-word-style
select-word-style bash

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

source /usr/share/doc/pkgfile/command-not-found.zsh

# History settings
HISTFILE=~/.history
HISTSIZE=10000
SAVEHIST=10000
setopt append_history
setopt extended_history
setopt hist_ignore_dups
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
feeds=~/git/ygt_feeds
searcher=~/git/searcher
sales=~/git/sales
spabreaks=~/git/spabreaks
yourteetimes=~/git/yourteetimes
: ~dotfiles ~charon ~spin ~frontend ~puppet ~feeds ~searcher ~sales ~spabreaks ~yourteetimes

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
      $path)

# Export section
export TERM=xterm-256color
export EDITOR=vim
export SHELL=/bin/zsh
export PAGER=less
export LANG=en_US.utf-8
export GOPATH=~/git
export RUBY_GC_MALLOC_LIMIT=90000000
export RUBY_GC_HEAP_FREE_SLOTS=200000
export FZF_DEAFULT_COMMAND='rg --files --no-ignore --hidden --follow --glob "!.git/*"'

# Start qiv with: fulscreen, atorotate, scaling large images down and no status bar.
alias qiv='qiv -f -l -t -i $1'

# Keychain activation.
eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)

# Initialize rbenv
eval "$(rbenv init -)"

# Aliases for different ls commands
alias ls='ls --color=auto'
alias ll='ls -l'
alias l='ls -al'

# Some aliases
alias sudo='sudo -E'
alias vi=vim
alias md='mkdir -p'

alias psack='ps aux | rg $1'
alias expack='export | rg $1'
alias lack='l | rg $1'
alias nara="sudo shutdown -hP now"

# Git aliases
alias g='git'
alias ga='git add'
alias gb='git branch'
alias gc='git commit -v'
alias gco='git checkout'
alias gd='git diff'
alias gdca='git diff --cached'
alias gl='git pull'
alias glog='git log --oneline --decorate --graph'
alias gp='git push -u'
alias grec="git reflog | rg checkout | head | cut -d' ' -f6"
alias grhh="git reset --hard HEAD"
alias gst='git status'
alias gsta='git stash save'
alias gstp='git stash pop'

alias rs='bin/rails s'
alias rc='bin/rails c'

alias yain='yaourt -S'
alias yaloc='yaourt -Qi'
alias yalocs='yaourt -Qs'
alias yaorph='yaourt -Qtd'
alias yarem='yaourt -Rns'
alias yaupg='yaourt -Syua'

alias nvm-init='source /usr/share/nvm/init-nvm.sh && nvm use'

function mkcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# added by travis gem
[ -f /home/gat/.travis/travis.sh ] && source /home/gat/.travis/travis.sh

# The next line updates PATH for the Google Cloud SDK.
if [ -f /home/gat/git/spabreaks/google-cloud-sdk/path.zsh.inc ]; then
  source '/home/gat/git/spabreaks/google-cloud-sdk/path.zsh.inc'
fi

# The next line enables shell command completion for gcloud.
if [ -f /home/gat/git/spabreaks/google-cloud-sdk/completion.zsh.inc ]; then
  source '/home/gat/git/spabreaks/google-cloud-sdk/completion.zsh.inc'
fi
