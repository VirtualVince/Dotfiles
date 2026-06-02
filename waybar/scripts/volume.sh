#!/bin/bash
vol_info=$(wpctl get-volume @DEFAULT_AUDIO_SINK@ 2>/dev/null)
vol=$(echo "$vol_info" | awk '{printf "%d", $2 * 100}')

if echo "$vol_info" | grep -q MUTED; then
    echo "{\"text\":\"muted\",\"class\":\"muted\",\"tooltip\":\"click to unmute\"}"
else
    echo "{\"text\":\"vol ${vol}%\",\"class\":\"normal\",\"tooltip\":\"scroll to adjust\\nclick to mute\"}"
fi
