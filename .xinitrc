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

# Setup display for dual screen
# Use config at /etc/X11/xorg.conf
#xrandr --output HDMI2 --auto --output LVDS1 --auto --right-of HDMI2

#sudo dhcpcd
#sudo wpa_supplicant -B -Dwext -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf

# Turn numlock on
numlockx &

# Start MPD
mpd ~/dotfiles/.mpdconf

# Disable touchpad while typing
syndaemon -t -k -i 2 -d &

# Start awesome
exec /usr/bin/awesome >> ~/.cache/awesome/stdout 2>> ~/.cache/awesome/stderr
