# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# Aliases for different ls commands
alias ls='ls --color=auto'
alias ll='ls -l'
alias l='ls -al'

# Export section
export TERM=xterm-256color
export EDITOR=vim
export GIT_PS1_SHOWDIRTYSTATE="OK"
export PATH="/usr/bin/vendor_perl:$HOME/.rbenv/bin:$HOME/.gem/ruby/1.9.1/bin:$HOME/scripts:$PATH"
export HISTSIZE=2000
export LANG=en_US.utf-8

# Command prompt in git shows branch name and working copy status
BROWN="\[\033[0;33m\]"
GREEN="\[\033[0;36m\]"
GREY="\[\033[m\]"
PS1=$GREY'[\u@\h '$BROWN'\w'$GREEN'$(__git_ps1 " (%s)")'$GREY'\[\]]# '

# Start qiv with: fulscreen, atorotate, scaling large images down and no status bar.
alias qiv='qiv -f -l -t -i $1'

# Some aliases
alias sudo='sudo -E'
alias vi=vim
alias gitcom='git commit -a'
alias gitst='git status'
alias psack='ps aux | ack $1'
alias expack='export | ack $1'
alias lack='l | ack $1'
alias nara="sudo shutdown -hP now"
alias wifi="sudo wifi-menu"

# Path aliases (Git mostly)
alias cdf='cd ~/git/frontend'
alias cdr='cd ~/git/roads'

# Set up default options for rdesktop
alias rdesktop='rdesktop -g 1366x768 -P -z -x l -r sound:off'

# Sourcing git completion file
source /usr/share/git/git-prompt.sh
source /usr/share/git/completion/git-completion.bash

# Keychain activation.
eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)

# Initialize rbenv
eval "$(rbenv init -)"

# Clear screen with ctrl+l
bind -m vi-insert "\C-l":clear-screen
