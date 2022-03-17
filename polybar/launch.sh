#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# Launch bar
echo "---" | tee -a /tmp/polybar.log
for m in $(polybar --list-monitors | cut -d":" -f1); do
  MONITOR=$m polybar bar 2>&1 | tee -a /tmp/polybar.log & disown
done
echo "Bars launched..."
