#!/bin/bash
chosen=$(printf "shutdown\nreboot\nsuspend" | rofi -dmenu \
    -p "" \
    -theme-str 'window { width: 160px; } listview { lines: 3; }')

case "$chosen" in
    shutdown) systemctl poweroff ;;
    reboot)   systemctl reboot ;;
    suspend)  systemctl suspend ;;
esac
