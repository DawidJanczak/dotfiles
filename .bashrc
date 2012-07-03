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
export PATH="$HOME/.rbenv/bin:$PATH"
export HISTSIZE=2000

# Command prompt in git shows branch name and working copy status
PS1='[\u@\h \W$(__git_ps1 " (%s)")]# '

# Start qiv with: fulscreen, atorotate, scaling large images down and no status bar.
alias qiv='qiv -f -l -t -i $1'

# Some aliases
alias sudo='sudo -E'
alias vi=vim
alias gitcom='git commit -a'
alias psack='ps aux | ack $1'
alias expack='export | ack $1'
alias lack='l | ack $1'
alias lock='xscreensaver-command -lock'
alias filename="$HOME/scripts/filename.rb $1"
alias delete_all_but="$HOME/scripts/delete_all_but.rb $@"
alias nara="sudo shutdown -hP now"

# Sourcing git completion file
source /usr/share/git/completion/git-completion.bash

eval "$(rbenv init -)"

# Keychain activation.
eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)

# Clear screen with ctrl+l
bind -m vi-insert "\C-l":clear-screen
