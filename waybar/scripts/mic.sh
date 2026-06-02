#!/bin/bash
if pactl get-source-mute @DEFAULT_SOURCE@ 2>/dev/null | grep -q 'yes'; then
    echo "{\"text\":\"mic off\",\"class\":\"muted\",\"tooltip\":\"microphone muted\"}"
else
    echo "{\"text\":\"mic\",\"class\":\"active\",\"tooltip\":\"microphone live\"}"
fi
