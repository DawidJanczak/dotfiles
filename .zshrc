#!/usr/bin/env zsh
# oh-my-zsh

autoload -Uz zmv
autoload -Uz compinit && compinit

zstyle ':completion:*' menu select

# Path to your oh-my-zsh configuration.
ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
#ZSH_THEME="random"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(archlinux
         bundler
         git
         rails
         systemd
         npm
)

DISABLE_AUTO_UPDATE=true
source $ZSH/oh-my-zsh.sh

setopt completealiases

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
HISTSIZE=5000
SAVEHIST=5000
setopt append_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_no_functions
unsetopt hist_verify

# MISC zsh settings
setopt noclobber
setopt auto_cd
setopt multios
unsetopt correctall

# Named directories
dotfiles=~/dotfiles
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
path=(./node_modules/.bin
      /usr/bin/vendor_perl
      ~/.rbenv/bin
      ~/scripts
      $path)

# Export section
export TERM=xterm-256color
export EDITOR=vim
export LANG=en_US.utf-8
export GOPATH=~/git
export RUBY_GC_MALLOC_LIMIT=90000000
export RUBY_GC_HEAP_FREE_SLOTS=200000

# Start qiv with: fulscreen, atorotate, scaling large images down and no status bar.
alias qiv='qiv -f -l -t -i $1'
#
# Set up default options for rdesktop
alias rdesktop='rdesktop -g 1366x768 -P -z -x l -r sound:off'

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
alias go='go'
alias vi=vim
alias gitcom='git commit -a'
alias gitst='git status'

alias psack='ps aux | ack $1'
alias expack='export | ack $1'
alias lack='l | ack $1'
alias nara="sudo shutdown -hP now"
alias wifi="sudo wifi-menu"

function mkcd {
  [[ -n "$1" ]] && mkdir -p "$1" && builtin cd "$1"
}
