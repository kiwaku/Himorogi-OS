#!/bin/bash
for DEV in $(ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$'); do
  ip link set "$DEV" down 2>/dev/null
  macchanger -r "$DEV"       >/dev/null 2>&1
  ip link set "$DEV" up   2>/dev/null
done
