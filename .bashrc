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
export PATH="/usr/bin/vendor_perl:$HOME/.gem/ruby/1.9.1/bin:$HOME/scripts:$PATH"
export HISTSIZE=2000
export LANG=en_US.utf-8

# Command prompt in git shows branch name and working copy status
BROWN="\[\033[0;33m\]"
GREY="\[\033[m\]"
PS1=$GREY'[\u@\h \w'$BROWN'$(__git_ps1 " (%s)")'$GREY'\[\]]# '

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

# Sourcing git completion file
source /usr/share/git/git-prompt.sh
source /usr/share/git/completion/git-completion.bash

# Keychain activation.
eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)

# Alias git as hub.
eval "$(hub alias -s)"

# Clear screen with ctrl+l
bind -m vi-insert "\C-l":clear-screen

rvm_project_rvmrc=1
[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm"
PATH=$PATH:$HOME/.rvm/bin:$HOME/.gem/jruby/1.9/bin # Add RVM to PATH for scripting
