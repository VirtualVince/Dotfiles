#!/bin/bash
for iface in tun0 tun1 wg0 wg1; do
    if ip link show "$iface" 2>/dev/null | grep -q "UP"; then
        ip=$(ip addr show "$iface" | awk '/inet /{print $2}' | cut -d/ -f1)
        echo "{\"text\":\"vpn on\",\"class\":\"active\",\"tooltip\":\"${iface}: ${ip}\"}"
        exit 0
    fi
done

echo "{\"text\":\"vpn off\",\"class\":\"inactive\",\"tooltip\":\"no active VPN interface\"}"
