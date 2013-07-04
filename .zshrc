autoload -U compinit promptinit
compinit
promptinit

prompt walters

zstyle ':completion:*' menu select

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
typeset -A key
key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}

# setup key accordingly
[[ -n "${key[Home]}"    ]]  && bindkey  "${key[Home]}"    beginning-of-line
[[ -n "${key[End]}"     ]]  && bindkey  "${key[End]}"     end-of-line
[[ -n "${key[Insert]}"  ]]  && bindkey  "${key[Insert]}"  overwrite-mode
[[ -n "${key[Delete]}"  ]]  && bindkey  "${key[Delete]}"  delete-char
[[ -n "${key[Up]}"      ]]  && bindkey  "${key[Up]}"      up-line-or-history
[[ -n "${key[Down]}"    ]]  && bindkey  "${key[Down]}"    down-line-or-history
[[ -n "${key[Left]}"    ]]  && bindkey  "${key[Left]}"    backward-char
[[ -n "${key[Right]}"   ]]  && bindkey  "${key[Right]}"   forward-char

source /usr/share/doc/pkgfile/command-not-found.zsh

# History settings
histsize=1000
savehist=1000
histfile=~/.history
setopt inc_append_history
setopt extended_history
setopt hist_ignore_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt hist_no_functions

setopt noclobber

autoload -U colors && colors
export PROMPT='%B%(?..[%?] )%b%n@%U%m%u> '
export RPROMPT="%F{green}%~%f"

setopt auto_cd
setopt multios
setopt correct

# Named directories
spin=~/git/spin
frontend=~/git/frontend
: ~spin ~frontend

# TODO
# BASHRC SECTION - cleanup!!!

# Aliases for different ls commands
alias ls='ls --color=auto'
alias ll='ls -l'
alias l='ls -al'

# PATH
typeset -U path
path=(/usr/bin/vendor_perl
      ~/.rbenv/bin
      ~/.gem/ruby/2.0.0/bin
      ~/.gem/ruby/1.9.1/bin
      ~/.gem/ruby/1.8/bin
      ~/scripts
      $path)

# Export section
export TERM=xterm-256color
export EDITOR=vim
export GIT_PS1_SHOWDIRTYSTATE="OK"
#export PATH="/usr/bin/vendor_perl:$HOME/.rbenv/bin:$HOME/.gem/ruby/2.0.0/bin:$HOME/.gem/ruby/1.9.1/bin:$HOME/scripts:$HOME/.gem/ruby/1.8/bin:$PATH"
export HISTSIZE=2000
export LANG=en_US.utf-8

# Command prompt in git shows branch name and working copy status
BROWN="\[\033[0;33m\]"
GREEN="\[\033[0;36m\]"
GREY="\[\033[m\]"
#PS1=$GREY'[\u@\h '$BROWN'\w'$GREEN'$(__git_ps1 " (%s)")'$GREY'\[\]]# '

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

# Set up default options for rdesktop
alias rdesktop='rdesktop -g 1366x768 -P -z -x l -r sound:off'

# Keychain activation.
eval $(keychain --eval --agents ssh -Q --quiet ~/.ssh/id_rsa)

# Initialize rbenv
eval "$(rbenv init -)"
