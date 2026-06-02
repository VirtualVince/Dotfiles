#!/bin/bash
IFS=', ' read -r temp usage < <(nvidia-smi --query-gpu=temperature.gpu,utilization.gpu --format=csv,noheader,nounits 2>/dev/null)

if [ -z "$temp" ]; then
    echo "{\"text\":\"gpu N/A\",\"class\":\"normal\"}"
    exit 0
fi

usage="${usage// /}"

if   [ "$usage" -ge 90 ]; then class="critical"
elif [ "$usage" -ge 70 ]; then class="warning"
else                            class="normal"
fi

echo "{\"text\":\"gpu ${usage}%  ${temp}°C\",\"class\":\"${class}\",\"tooltip\":\"GPU usage: ${usage}%\\nGPU temp: ${temp}°C\"}"
