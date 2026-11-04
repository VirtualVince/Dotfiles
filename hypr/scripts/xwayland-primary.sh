#!/bin/sh
# Make the Acer the XWayland/RandR primary output (Wine/Proton uses it as the
# Windows primary display). Resolves the connector name at runtime because it
# changes with GPU driver load order.
out=$(hyprctl monitors | awk '/^Monitor /{m=$2} /description: Acer Technologies Acer K272HL/{print m; exit}')
[ -n "$out" ] && xrandr --output "$out" --primary
