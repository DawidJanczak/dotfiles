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

# Turn off energy saving on monitor
# xset -dpms

# Add some fonts location
xset +fp /usr/share/fonts/local
xset fp rehash

# Run devmon in background
devmon &

# Setup display for dual screen
# Use config at /etc/X11/xorg.conf
#xrandr --output HDMI2 --auto --output LVDS1 --auto --right-of HDMI2

#sudo dhcpcd
#sudo wpa_supplicant -B -Dwext -i wlan0 -c /etc/wpa_supplicant/wpa_supplicant.conf

# Turn numlock on
#numlockx &

# Start MPD
#mpd ~/dotfiles/.mpdconf

# Disable touchpad while typing
# syndaemon -t -k -i 2 -d &

# Disable touchpad when mouse is connected
# TODO check if this is needed
# ls /dev/input/by-id/*-mouse && synclient TouchpadOff=1

# Autostart desktop apps
dex -a -e Awesome &

# fcitx env vars
export _JAVA_AWT_WM_NONREPARENTING=1

# Ibus setup
export GTK_IM_MODULE=ibus
export XMODIFIERS=@im=ibus
export QT_IM_MODULE=ibus
ibus-daemon -dr --xim

# Enable numlock
numlockx &

# Start copyq
copyq &

# NetworkManager applet
nm-applet &

# Start xsession target that binds to graphical session
# Required for Redshift
# https://github.com/jonls/redshift/issues/265
# https://superuser.com/a/1128905
systemctl --user import-environment PATH DBUS_SESSION_BUS_ADDRESS
systemctl --no-block --user start xsession.target

# Start i3
# Use 25 MiB of RAM for debug logs
exec i3 -V -d all &>> "$HOME/i3.log"
