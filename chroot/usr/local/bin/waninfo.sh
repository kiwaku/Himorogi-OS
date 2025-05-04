#!/bin/bash
# Print WAN IP  +  simple NIC status
for i in 1 2 3; do
    if command -v nmcli >/dev/null 2>&1; then
        STATE=$(nmcli -t -f STATE g 2>/dev/null)
        [ "$STATE" != "connecting" ] && break
        sleep 1
    fi
done
if command -v nmcli >/dev/null 2>&1; then
    echo "LAN: $STATE"
else
    echo "LAN: unknown"
fi
WAN=$(curl -s --max-time 2 https://ipinfo.io/ip || curl -s --max-time 2 https://ifconfig.me 2>/dev/null)
[ -n "$WAN" ] && echo "WAN: $WAN"
