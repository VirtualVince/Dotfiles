#!/bin/bash
# Read /proc/stat twice to compute real usage delta
read_stat() {
    awk '/^cpu /{total=0; for(i=2;i<=9;i++) total+=$i; print total, $5+$6}' /proc/stat
}

IFS=' ' read -r t1 i1 < <(read_stat)
sleep 0.3
IFS=' ' read -r t2 i2 < <(read_stat)

dt=$(( t2 - t1 ))
di=$(( i2 - i1 ))
usage=$(( (dt - di) * 100 / dt ))

temp=$(sensors 2>/dev/null | awk '/Package id 0/{gsub(/[+°C]/,"",$4); print int($4)}')
temp=${temp:-"N/A"}

if   [ "$usage" -ge 90 ]; then class="critical"
elif [ "$usage" -ge 70 ]; then class="warning"
else                            class="normal"
fi

echo "{\"text\":\"cpu ${usage}%  ${temp}°C\",\"class\":\"${class}\",\"tooltip\":\"CPU usage: ${usage}%\\nPackage temp: ${temp}°C\"}"
