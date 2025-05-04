#!/bin/bash
echo "Select proxy routing:"
echo "[1] Direct Connection (Default)"
echo "[2] Tor (via torsocks prefix)"
echo "[3] Proxychains (Edit /etc/proxychains.conf first)"
read -p "Choice [1]: " choice
case "$choice" in
  1)
    unset ALL_PROXY HTTP_PROXY HTTPS_PROXY FTP_PROXY SOCKS_PROXY
    echo "Proxy environment variables unset. Connection is direct."
    ;;
  2)
    echo "Tor selected. Prefix commands needing Tor with 'torsocks'."
    echo "Example: torsocks curl https://check.torproject.org/"
    ;;
  3)
    if [ -f /etc/proxychains.conf ]; then
      echo "Proxychains selected. Prefix commands with 'proxychains4'."
      echo "Example: proxychains4 curl ifconfig.me"
      echo "Ensure /etc/proxychains.conf is configured correctly."
    else
      echo "Error: /etc/proxychains.conf not found."
    fi
    ;;
  *)
    unset ALL_PROXY HTTP_PROXY HTTPS_PROXY FTP_PROXY SOCKS_PROXY
    echo "Invalid choice or default. Connection is direct."
    ;;
esac
