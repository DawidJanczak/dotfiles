#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx (run your window manager from here)

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi

[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources

# exec gnome-session
# exec startkde
# exec startxfce4
# ...or the Window Manager of your choice

# Mute PC speaker
xset -b

# Turn off energy saving on monitor
xset -dpms

# Add some fonts location
xset +fp /usr/share/fonts/local
xset fp rehash

# Run devmon in background
devmon &

# Source Xresources
xrdb -merge ~/.Xresources

# Set polish keyboard map for X applications
setxkbmap pl

# Start awesome
exec awesome
