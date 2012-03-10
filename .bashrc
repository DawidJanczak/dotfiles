# If not running interactively, don't do anything
[[ $- != *i* ]] && return

alias ls='ls --color=auto'
alias ll='ls -l'
alias l='ls -al'

export TERM=xterm-256color
export EDITOR=vim
export GIT_PS1_SHOWDIRTYSTATE="OK"

PS1='[\u@\h \W$(__git_ps1 " (%s)")]# '

alias sudo='sudo -E'
alias vi=vim
alias gitcom='git commit -am $1'
alias psack='ps aux | ack $1'
alias expack='export | ack $1'

source /usr/share/git/completion/git-completion.bash
