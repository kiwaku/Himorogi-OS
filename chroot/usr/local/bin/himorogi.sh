#!/bin/bash
clear
echo -e "\e[1;35mWelcome to Himorogi — Terminal OS for Recon and Peace\e[0m"
echo "System:  $(lsb_release -ds 2>/dev/null || echo Debian)  ($(uname -r))"
echo "Running live from RAM; all changes vanish on reboot."
echo "Login user: $(whoami)"
echo

##### 1. LAN status (loop up to 3 s for NetworkManager) #####
if command -v nmcli >/dev/null 2>&1; then
  for i in 1 2 3; do
    LAN_STATE=$(nmcli -t -f STATE g 2>/dev/null)
    [ "$LAN_STATE" != "connecting" ] && break
    sleep 1
  done
  echo "LAN: $LAN_STATE"
else
  UP_IF=$(ip -o link show | awk '/state UP/ {print $2}' | sed 's/://;1q')
  echo "LAN: ${UP_IF:-disconnected}"
fi

##### 2. WAN IP + country (2 s timeout) #####
WAN=$(curl -s --max-time 2 https://ipinfo.io/json \
      | awk -F\" '/"ip":/ {ip=$4} /"country":/ {cc=$4} END {print ip" "(cc)}')
[ -z "$WAN" ] && WAN=$(curl -s --max-time 2 https://ifconfig.me 2>/dev/null)
[ -n "$WAN" ] && echo "WAN: $WAN"

##### 3. Show MAC addresses currently in use #####
printf "MACs:"
ip -o link | awk '/link\/ether/ {print " "$2":"$17}'
echo -e "\n"

echo "Helper scripts: proxy_select.sh | mount_usb.sh | wipe_and_exit.sh"
echo "Run \e[1mwipe\e[0m to securely wipe & power‑off."
echo "Type a command to begin."
