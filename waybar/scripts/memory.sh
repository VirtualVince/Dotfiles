#!/bin/bash
IFS=' ' read -r _ total used free _ < <(free -m | awk '/^Mem:/')

used_gb=$(awk "BEGIN{printf \"%.1f\", $used/1024}")
total_gb=$(awk "BEGIN{printf \"%.1f\", $total/1024}")
pct=$(( used * 100 / total ))

if   [ "$pct" -ge 90 ]; then class="critical"
elif [ "$pct" -ge 75 ]; then class="warning"
else                          class="normal"
fi

echo "{\"text\":\"ram ${used_gb}G / ${total_gb}G\",\"class\":\"${class}\",\"tooltip\":\"${pct}% used\"}"
