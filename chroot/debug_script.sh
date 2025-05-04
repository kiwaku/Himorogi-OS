#!/bin/bash

# Script to gather debugging information after user removal and root config changes.
# Run this script INSIDE the chroot environment.
# Output will be saved to /debug_info.txt within the chroot.

OUTPUT_FILE="/debug_info.txt"

echo "--- Debug Information Gatherer ---" > "$OUTPUT_FILE"
echo "Timestamp: $(date)" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"
echo "--- Checking Modified Scripts ---" >> "$OUTPUT_FILE"
echo "--- /usr/local/bin/himorogi.sh ---" >> "$OUTPUT_FILE"
if [ -f "/usr/local/bin/himorogi.sh" ]; then
  ls -l /usr/local/bin/himorogi.sh >> "$OUTPUT_FILE"
  cat /usr/local/bin/himorogi.sh >> "$OUTPUT_FILE"
else
  echo "File NOT FOUND: /usr/local/bin/himorogi.sh" >> "$OUTPUT_FILE"
fi
echo "---------------------------------" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "--- /usr/local/bin/wipe_and_exit.sh ---" >> "$OUTPUT_FILE"
if [ -f "/usr/local/bin/wipe_and_exit.sh" ]; then
  ls -l /usr/local/bin/wipe_and_exit.sh >> "$OUTPUT_FILE"
  cat /usr/local/bin/wipe_and_exit.sh >> "$OUTPUT_FILE"
else
  echo "File NOT FOUND: /usr/local/bin/wipe_and_exit.sh" >> "$OUTPUT_FILE"
fi
echo "-------------------------------------" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "--- Checking Relocated Scripts Location (/root/scripts) ---" >> "$OUTPUT_FILE"
echo "--- Directory Listing: /root/scripts ---" >> "$OUTPUT_FILE"
if [ -d "/root/scripts" ]; then
  ls -la /root/scripts/ >> "$OUTPUT_FILE"
  echo "--- Contents of scripts in /root/scripts ---" >> "$OUTPUT_FILE"
  # List contents of shell scripts found
  find /root/scripts -maxdepth 1 -type f -name '*.sh' -print -exec echo "--- Content of {} ---" \; -exec cat {} \; -exec echo "--- End of {} ---" \; >> "$OUTPUT_FILE" 2>&1
else
  echo "Directory NOT FOUND: /root/scripts" >> "$OUTPUT_FILE"
fi
echo "---------------------------------------" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "--- Checking Root's Bash Configuration ---" >> "$OUTPUT_FILE"
echo "--- /root/.bashrc ---" >> "$OUTPUT_FILE"
if [ -f "/root/.bashrc" ]; then
  ls -l /root/.bashrc >> "$OUTPUT_FILE"
  cat /root/.bashrc >> "$OUTPUT_FILE"
else
  echo "File NOT FOUND: /root/.bashrc" >> "$OUTPUT_FILE"
fi
echo "---------------------" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "--- Checking User/Group Files for 'kara' ---" >> "$OUTPUT_FILE"
echo "--- grep 'kara' /etc/passwd ---" >> "$OUTPUT_FILE"
grep "kara" /etc/passwd >> "$OUTPUT_FILE" || echo "No 'kara' found in /etc/passwd." >> "$OUTPUT_FILE"
echo "-------------------------------" >> "$OUTPUT_FILE"
echo "--- grep 'kara' /etc/shadow ---" >> "$OUTPUT_FILE"
grep "kara" /etc/shadow >> "$OUTPUT_FILE" || echo "No 'kara' found in /etc/shadow." >> "$OUTPUT_FILE"
echo "-------------------------------" >> "$OUTPUT_FILE"
echo "--- grep 'kara' /etc/group ---" >> "$OUTPUT_FILE"
grep "kara" /etc/group >> "$OUTPUT_FILE" || echo "No 'kara' found in /etc/group." >> "$OUTPUT_FILE"
echo "------------------------------" >> "$OUTPUT_FILE"
echo "--- grep 'kara' /etc/gshadow ---" >> "$OUTPUT_FILE"
grep "kara" /etc/gshadow >> "$OUTPUT_FILE" || echo "No 'kara' found in /etc/gshadow." >> "$OUTPUT_FILE"
echo "--------------------------------" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

echo "--- Checking /root directory permissions ---" >> "$OUTPUT_FILE"
ls -ld /root >> "$OUTPUT_FILE"
echo "------------------------------------------" >> "$OUTPUT_FILE"
echo "" >> "$OUTPUT_FILE"

# Add any other files you suspect might be relevant
# echo "--- Checking /etc/fstab ---" >> "$OUTPUT_FILE"
# if [ -f "/etc/fstab" ]; then cat /etc/fstab >> "$OUTPUT_FILE"; else echo "File NOT FOUND: /etc/fstab" >> "$OUTPUT_FILE"; fi
# echo "-------------------------" >> "$OUTPUT_FILE"
# echo "" >> "$OUTPUT_FILE"

echo "--- Debug Information Gathering Complete ---" >> "$OUTPUT_FILE"
echo "Output saved to $OUTPUT_FILE"
