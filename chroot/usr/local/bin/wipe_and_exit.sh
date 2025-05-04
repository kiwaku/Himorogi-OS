#!/bin/bash
# /usr/local/bin/wipe_and_exit.sh
# Run this script with sudo or as root for full effect.

echo "INFO: Starting secure wipe and shutdown process..."

# Check if running as root
if [ "$(id -u)" -ne 0 ]; then
  echo "WARNING: Not running as root. Some system logs may not be cleared."
  echo "Attempting user-level cleanup..."
fi

# --- File System Wiping ---
echo "INFO: Wiping volatile user and system directories..."

# User-specific files (use find to handle non-existent files gracefully)
# Add other user-specific files/dirs if needed

# Root user history
rm -f /root/.bash_history
rm -f /root/.viminfo

# Common temporary locations
rm -rf /tmp/* /var/tmp/*

# System logs (requires root/sudo)
# Standard logs - may not exist if journald is primary, but good to clear
rm -rf /var/log/*.log /var/log/syslog /var/log/messages /var/log/auth.log
rm -rf /var/log/apt/* /var/log/dpkg.log
# Journald logs (if journald wasn't disabled/masked during build)
# Consider running 'journalctl --rotate && journalctl --vacuum-time=1s' before removing
rm -rf /var/log/journal/*
# Other potential log/backup locations
rm -rf /var/backups/*

echo "INFO: Volatile directories wiped."

# --- Shell History ---
echo "INFO: Clearing current shell history..."
history -c # Clear history for the *current* shell instance running the script

# If run as user 'kar-a, also try clearing their history buffer (may be redundant)


# --- Sync Filesystem ---
echo "INFO: Syncing filesystem buffers..."
sync; sync; sync

# --- Final Shutdown ---
echo "INFO: Wipe complete. Powering off NOW."
sleep 2

# Force immediate poweroff
# Use poweroff -f or systemctl poweroff --force --no-wall
poweroff -f

exit 0 # Exit script cleanly (though poweroff usually prevents this)
