rm -f /root/.bash_history /home/kara/.bash_history
exit
echo "Forcing essential modules into initramfs..."
# Add modules likely needed for USB boot and SquashFS/Overlay
echo "usbcore" >> /etc/initramfs-tools/modules
echo "xhci_hcd" >> /etc/initramfs-tools/modules # USB 3.0
echo "ehci_hcd" >> /etc/initramfs-tools/modules # USB 2.0
echo "uhci_hcd" >> /etc/initramfs-tools/modules # USB 1.1
echo "usbhid" >> /etc/initramfs-tools/modules   # USB Input Devices (Keyboard)
echo "hid-generic" >> /etc/initramfs-tools/modules
echo "sd_mod" >> /etc/initramfs-tools/modules   # SCSI Disk support (used by USB storage)
echo "sr_mod" >> /etc/initramfs-tools/modules   # CD-ROM support (if booting ISO)
echo "iso9660" >> /etc/initramfs-tools/modules  # ISO9660 filesystem
echo "vfat" >> /etc/initramfs-tools/modules     # FAT filesystem (common on USB sticks)
echo "nls_cp437" >> /etc/initramfs-tools/modules # Needed for FAT
echo "nls_iso8859-1" >> /etc/initramfs-tools/modules # Needed for FAT/ISO
echo "squashfs" >> /etc/initramfs-tools/modules # SquashFS filesystem
echo "overlay" >> /etc/initramfs-tools/modules  # Overlay filesystem
sort -u /etc/initramfs-tools/modules -o /etc/initramfs-tools/modules
echo "Modules added/updated in /etc/initramfs-tools/modules. Content:"
cat /etc/initramfs-tools/modules
# Regenerate the initramfs for all installed kernels
echo "Updating initramfs (this may take a moment)..."
update-initramfs -u -k all
exit
locale
echo "Forcing essential modules into initramfs..."
# Add modules likely needed for USB boot and SquashFS/Overlay
echo "usbcore" >> /etc/initramfs-tools/modules
echo "xhci_hcd" >> /etc/initramfs-tools/modules # USB 3.0
echo "ehci_hcd" >> /etc/initramfs-tools/modules # USB 2.0
echo "uhci_hcd" >> /etc/initramfs-tools/modules # USB 1.1
echo "usbhid" >> /etc/initramfs-tools/modules   # USB Input Devices (Keyboard)
echo "hid-generic" >> /etc/initramfs-tools/modules
echo "sd_mod" >> /etc/initramfs-tools/modules   # SCSI Disk support (used by USB storage)
echo "sr_mod" >> /etc/initramfs-tools/modules   # CD-ROM support (if booting ISO)
echo "iso9660" >> /etc/initramfs-tools/modules  # ISO9660 filesystem
echo "vfat" >> /etc/initramfs-tools/modules     # FAT filesystem (common on USB sticks)
echo "nls_cp437" >> /etc/initramfs-tools/modules # Needed for FAT
echo "nls_iso8859-1" >> /etc/initramfs-tools/modules # Needed for FAT/ISO
echo "squashfs" >> /etc/initramfs-tools/modules # SquashFS filesystem
echo "overlay" >> /etc/initramfs-tools/modules  # Overlay filesystem
# Make the list unique in case some were already there
sort -u /etc/initramfs-tools/modules -o /etc/initramfs-tools/modules
echo "Modules added/updated in /etc/initramfs-tools/modules. Content:"
cat /etc/initramfs-tools/modules
# Regenerate the initramfs for all installed kernels
echo "Updating initramfs (this may take a moment)..."
update-initramfs -u -k all
echo "Initramfs update complete. Check for errors above."
exit
locate isolinux.cfg
isolinux.cfg
ls
sudo nano iso/isolinux/isolinux.cfg
exit
[200~sudo nano iso/isolinux/isolinux.cfg~
sudo nano iso/isolinux/isolinux.cfg
exit
sudo nano iso/isolinux/isolinux.cfg
ls
exit
mkdir -p /etc/systemd/system/getty@tty1.service.d
cat > /etc/systemd/system/getty@tty1.service.d/override.conf <<'EOF'
[Service]
ExecStart=
ExecStart=-/sbin/agetty --autologin root --noclear %I $TERM
EOF

ln -sf /lib/systemd/system/multi-user.target /etc/systemd/system/default.target
exit
# --- Run these checks INSIDE the chroot ---
echo "--- Performing Final Checks for Root-Only System ---"
# 1. Check User/Group Removal
echo "[Check 1/6] Verifying 'kara' user and group removal..."
if id -u kara > /dev/null 2>&1; then   echo "  [FAIL] User 'kara' still exists!"; else   echo "  [OK] User 'kara' does not exist."; fi
if getent group kara > /dev/null 2>&1; then   echo "  [WARN] Group 'kara' still exists (may be harmless if empty)."; else   echo "  [OK] Group 'kara' does not exist."; fi
# Check key files just in case getent misses something
if grep -qw "^kara:" /etc/passwd /etc/shadow /etc/group /etc/gshadow; then     echo "  [FAIL] Found 'kara' references in /etc user/group files!"; else     echo "  [OK] No 'kara' references found in main /etc user/group files."; fi
# 2. Check Home Directory Absence
echo "[Check 2/6] Verifying /home/kara removal..."
if [ -d "/home/kara" ]; then   echo "  [FAIL] Directory /home/kara still exists!"; else   echo "  [OK] Directory /home/kara does not exist."; fi
# 3. Check Helper Script Relocation & Permissions
echo "[Check 3/6] Verifying helper scripts in /root/scripts..."
if [ -d "/root/scripts" ]; then   echo "  [OK] Directory /root/scripts exists.";   ls -l /root/scripts/ # Display contents and permissions
  [ -x "/root/scripts/proxy_select.sh" ] && echo "  [OK] proxy_select.sh is executable." || echo "  [FAIL] proxy_select.sh not found or not executable!";   [ -x "/root/scripts/mount_usb.sh" ] && echo "  [OK] mount_usb.sh is executable." || echo "  [FAIL] mount_usb.sh not found or not executable!"
  OWNER=$(stat -c '%U' /root/scripts);   [ "$OWNER" == "root" ] && echo "  [OK] /root/scripts owned by root." || echo "  [FAIL] /root/scripts owned by $OWNER!"; else   echo "  [FAIL] Directory /root/scripts does not exist!"; fi
# 4. Check Main Script Content
echo "[Check 4/6] Verifying paths in main scripts..."
if grep -q "/home/kara" /usr/local/bin/himorogi.sh; then   echo "  [FAIL] /home/kara path still found in himorogi.sh!"; else   echo "  [OK] No /home/kara path found in himorogi.sh."; fi
if grep -q "/home/kara" /usr/local/bin/wipe_and_exit.sh; then   echo "  [FAIL] /home/kara path still found in wipe_and_exit.sh!"; else   echo "  [OK] No /home/kara path found in wipe_and_exit.sh."; fi
# Check if the correct path exists now
if grep -q "/root/scripts" /usr/local/bin/himorogi.sh; then   echo "  [OK] /root/scripts path found in himorogi.sh."; else   echo "  [FAIL] /root/scripts path NOT found in himorogi.sh!"; fi
# 5. Check /root/.bashrc Configuration
echo "[Check 5/6] Verifying /root/.bashrc..."
if [ -f "/root/.bashrc" ]; then   echo "  [OK] /root/.bashrc exists.";   if grep -q '/usr/local/bin/himorogi.sh' /root/.bashrc; then     echo "  [OK] Himorogi autostart line found.";   else     echo "  [FAIL] Himorogi autostart line NOT found!";   fi;   if grep -q "PS1=.*\#" /root/.bashrc; then # Check for root prompt indicator '#'
    echo "  [OK] Custom root prompt line found (or similar).";   else     echo "  [WARN] Custom root prompt line not found or doesn't end with #.";   fi;   OWNER=$(stat -c '%U' /root/.bashrc);   [ "$OWNER" == "root" ] && echo "  [OK] /root/.bashrc owned by root." || echo "  [FAIL] /root/.bashrc owned by $OWNER!"; else   echo "  [FAIL] /root/.bashrc does not exist!"; fi
# 6. Basic Filesystem Check
echo "[Check 6/6] Basic filesystem checks..."
[ -d "/root" ] && echo "  [OK] /root directory exists." || echo "  [FAIL] /root directory missing!"
[ -d "/usr/local/bin" ] && echo "  [OK] /usr/local/bin exists." || echo "  [FAIL] /usr/local/bin missing!"
[ -x "/bin/bash" ] && echo "  [OK] /bin/bash exists and is executable." || echo "  [FAIL] /bin/bash missing or not executable!"
echo "--- Checks Complete ---"
echo "Review any [FAIL] or [WARN] messages above carefully before exiting the chroot."
# --- End of checks ---
exit
exit
exit
exit
sudo nano debug_script.sh
chmod +x /tmp/debug_script.sh
chmod +x debug_script.sh
sudoi ./debug_script.sh 
sudo ./debug_script.sh 
cat debug_info.txt 
# Remove the orphaned 'fi'
sed -i '/# If run as user.*history buffer/,/fi/ { /fi/d }' /usr/local/bin/wipe_and_exit.sh
# Verify (optional) - should show the line before '--- Sync Filesystem ---' without the 'fi'
tail -n 15 /usr/local/bin/wipe_and_exit.sh
sed -i 's/case "" in/case "$choice" in/' /root/scripts/proxy_select.sh
sed -i '/# Launch Himorogi tmux session/,/fi/ s/^/# /' /root/.bashrc
# Verify (optional) - should show the block commented out
grep -A 5 "# Launch Himorogi" /root/.bashrc
exit
# Run INSIDE the chroot
ls -ld / /etc /bin /sbin /lib* /usr /var /tmp /run /root /dev /proc /sys
# Run INSIDE the chroot
update-initramfs -u -k all
exit
update-initramfs -u
grep -Ri kara /etc 2>/dev/null
ls
rm -f /opt/himorogi-dev/iso/live/filesyst.squashfs
exit
# Safely remove kara lines from subuid and subgid
sed -i '/^kara:/d' /etc/subuid
sed -i '/^kara:/d' /etc/subgid
sed -i '/^kara:/d' /etc/subuid-
sed -i '/^kara:/d' /etc/subgid-
update-initramfs -u
exit
update-initramfs -u
exit
! grep -r 'kara' /etc /home /var 2>/dev/null && echo "✔ Kara fully removed"
update-initramfs -u
exit
cat /root/.bashrc
sudo nano /root/.bashrc
sed -i '/Launch Himorogi/,/fi/ s/^# //' /root/.bashrc
sed -i '/\/usr\/local\/bin\/himorogi.sh/i \  sleep 1' /root/.bashrc
exit
cat /usr/local/bin/himorogi.sh
cat /root/.bashrc
ls -l /usr/local/bin/himorogi.sh
command -v tmux || echo "❌ tmux not found"
exit
exit
echo 'source ~/.bashrc' >> /root/.bash_profile
exit
nano /usr/local/bin/himorogi.sh
nano /root/.bashrc
nano /root/.bashrc
exit
update-initramfs -u
exit
nano /usr/local/bin/himorogi.sh
chmod +x /usr/local/bin/himorogi.sh
update-initramfs -u
exit
mkdir -p /root/scripts
cat > /root/scripts/init_main_pane.sh <<'EOS'
#!/bin/bash
echo "Main Shell"
echo "Networking:"
ip a
echo
echo "Try: nmcli dev wifi list                    (if wifi detected)"
bash
EOS

chmod +x /root/scripts/init_main_pane.sh
nano /usr/local/bin/himorogi.sh
update-initramfs -u
exit
nano /root/.bash_profile
update-initramfs -u
exit
cat > /root/.bash_profile <<'EOF'
# ~/.bash_profile for Himorogi  (root autologin shell)

# Load global profile if present
[ -f /etc/profile ] && . /etc/profile

# Always load personal bashrc, so banner + tmux run
[ -f ~/.bashrc ] && . ~/.bashrc
EOF

echo "set -g status off" > /root/.tmux.conf
command -v tmux >/dev/null || apt-get update && apt-get install -y tmux
update-initramfs -u
exit    # leave chroot
chsh -s /bin/bash root
cat > /etc/profile.d/himorogi.sh <<'EOF'
# /etc/profile.d/himorogi.sh – run banner once per TTY login
if [ -z "$TMUX" ] && [[ "$(tty)" =~ /dev/tty[0-9]+$ ]]; then
  /usr/local/bin/himorogi.sh
fi
EOF

echo "set -g status off" > /root/.tmux.conf
update-initramfs -u
exit            # leave chroot
cat /etc/profile.d/himorogi.sh
nano  /usr/local/bin/himorogi.sh
cat /usr/local/bin/himorogi.sh
cat > /usr/local/bin/himorogi.sh <<'EOF'
#!/bin/bash
# Himorogi dashboard – banner + one helper pane

SESSION=himorogi

# Create session only if it does not already exist
if ! tmux has-session -t "$SESSION" 2>/dev/null; then
  # Window 0: Main banner
  tmux new-session  -d  -s "$SESSION" -n Main \
    'clear && \
     echo -e "\e[1;35mWelcome to Himorogi — Terminal OS for Recon and Peace\e[0m" && \
     echo "System:  \$(lsb_release -ds 2>/dev/null || echo Debian) (\$(uname -r))" && \
     echo "Live RAM session – changes vanish on reboot." && \
     echo && \
     if command -v nmcli >/dev/null; then \
       nmcli -t -f STATE g; nmcli -t -f DEVICE,TYPE,STATE device; \
     else \
       ip -o -4 addr show | awk \"{print \\$2 \\": \" \\$4}\"; \
     fi && \
     echo && \
     echo \"Type Ctrl‑b ? for tmux help\" && \
     bash'

  # Window 1: helper scripts
  tmux new-window -t "$SESSION":1 -n Scripts \
    'cd /root/scripts && ./proxy_select.sh || bash'
fi

exec tmux attach -t "$SESSION"
EOF

chmod +x /usr/local/bin/himorogi.sh
echo "set -g status off" > /root/.tmux.conf
if [[ -z "$TMUX" ]] && [[ "$(tty)" =~ /dev/tty[0-9]+$ ]]; then   export TERM=linux;   /usr/local/bin/himorogi.sh; fi
cat /root/.bash_profile
/root/.bash_profile
update-initramfs -u 
exit
# 1. Remove the banner‑launch block from /root/.bashrc
sed -i '/himorogi\.sh/d' /root/.bashrc
# 2. Give root a static prompt (# not counting commands)
sed -i "s|PS1='.*'|PS1='\\[\\e[1;31m\\]\\u@\\h\\[\\e[0m\\]:\\[\\e[1;34m\\]\\w\\[\\e[0m\\]\\# '|g" /root/.bashrc
# 3. Delete tmux config and, if you like, the package
rm -f /root/.tmux.conf
apt-get purge -y tmux || true
# 4. Replace /usr/local/bin/himorogi.sh with a banner‑only script
cat > /usr/local/bin/himorogi.sh <<'EOF'
#!/bin/bash
clear
echo -e "\e[1;35mWelcome to Himorogi — Terminal OS for Recon and Peace\e[0m"
echo "System:  $(lsb_release -ds 2>/dev/null || echo Debian) ($(uname -r))"
echo "Running live from RAM; all changes vanish on reboot."
echo "Login user: $(whoami)"
echo
if command -v nmcli &>/dev/null; then
  nmcli -t -f STATE g
  nmcli -t -f DEVICE,TYPE,STATE device
else
  ip -o -4 addr show | awk '{print $2": "$4}'
fi
echo
echo "Helper scripts: proxy_select.sh | mount_usb.sh | wipe_and_exit.sh"
echo "Type a command to begin."
EOF

chmod +x /usr/local/bin/himorogi.sh
# 5. Make sure every login shell actually shows the banner
cat > /etc/profile.d/himorogi-banner.sh <<'EOF'
# Show banner once per TTY login
if [[ -z "$BANNER_SHOWN" ]] && [[ "$(tty)" =~ /dev/tty[0-9]+$ ]]; then
  /usr/local/bin/himorogi.sh
  export BANNER_SHOWN=1
fi
EOF

# 6. Re‑generate initrd so the live initramfs matches the new root FS
update-initramfs -u
exit   # leave chroot
# Replace the PS1 definition with a simple root prompt
sed -i "s|^PS1=.*|PS1='\\u@\\h:\\w# '|g" /root/.bashrc
update-initramfs -u
exit
sed -i "s|^PS1=.*|PS1='\\\\u@\\\\h:\\\\w# '|g" /root/.bashrc
update-initramfs -u
exit
echo '/usr/local/bin/wipe_and_exit.sh' > /root/.bash_logout
chmod +x /root/.bash_logout
cat <<EOF > /etc/systemd/system/himorogi-wipe.service
[Unit]
Description=Secure wipe on shutdown
DefaultDependencies=no
Before=poweroff.target reboot.target halt.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/wipe_and_exit.sh
RemainAfterExit=yes

[Install]
WantedBy=poweroff.target reboot.target halt.target
EOF

# Enable it
systemctl enable himorogi-wipe.service
apt install -y ca-certificates
update-ca-certificates
ls -l /etc/ssl/certs/ca-certificates.crt
curl https://example.com
apt install -y macchanger
echo "ENABLE_ON_POST_UP=yes" > /etc/default/macchanger
echo "INTERFACE=all" >> /etc/default/macchanger
macchanger -r eth0
##### 1.1  install prerequisites
apt-get update
apt-get install -y macchanger curl jq
##### 1.2  network + location helper (fast, quiet)
cat > /usr/local/bin/waninfo.sh <<'EOWAN'
#!/bin/bash
IPJSON=$(curl -s --max-time 2 https://ipinfo.io/json || curl -s --max-time 2 https://ifconfig.me/ip)
if echo "$IPJSON" | grep -q '{'; then             # ipinfo JSON
  WAN=$(echo "$IPJSON" | jq -r '.ip? // empty')
  CC=$(echo "$IPJSON"  | jq -r '.country? // empty')
else                                               # plain IP from ifconfig.me
  WAN=$IPJSON
  CC=""
fi
[ -n "$WAN" ] && echo "WAN IP: $WAN ${CC:+($CC)}"
EOWAN

chmod +x /usr/local/bin/waninfo.sh
##### 1.3  patch himorogi.sh – add WAN info line
sed -i '/Network Status.*)/a \/usr\/local\/bin\/waninfo.sh' /usr/local/bin/himorogi.sh
##### 1.4  disable IPv6 (sysctl + kernel)
echo 'net.ipv6.conf.all.disable_ipv6 = 1'  >> /etc/sysctl.d/99-himorogi.conf
echo 'net.ipv6.conf.default.disable_ipv6 = 1' >> /etc/sysctl.d/99-himorogi.conf
# add kernel flag unless it’s already there
grep -q "ipv6.disable=1" /etc/default/grub ||   sed -i 's/GRUB_CMDLINE_LINUX="/GRUB_CMDLINE_LINUX="ipv6.disable=1 /' /etc/default/grub
update-grub 2>/dev/null || true    # ignore if grub not installed in chroot
##### 1.5  MAC randomiser
cat > /usr/local/bin/randomise_mac.sh <<'EOSH'
#!/bin/bash
for DEV in $(ip -o link show | awk -F': ' '{print $2}' | grep -v '^lo$'); do
  ip link set "$DEV" down 2>/dev/null
  macchanger -r "$DEV"       >/dev/null 2>&1
  ip link set "$DEV" up   2>/dev/null
done
EOSH

chmod +x /usr/local/bin/randomise_mac.sh
cat > /etc/systemd/system/mac-random.service <<'EOSVC'
[Unit]
Description=Randomise MAC addresses before network-up
Before=network-pre.target
Wants=network-pre.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/randomise_mac.sh

[Install]
WantedBy=multi-user.target
EOSVC

systemctl enable mac-random.service
##### 1.6  rebuild initramfs so MAC & IPv6 tweaks land in live initrd
update-initramfs -u
exit
# inside chroot – patch /usr/local/bin/waninfo.sh
cat > /usr/local/bin/waninfo.sh <<'EOF'
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
EOF

chmod +x /usr/local/bin/waninfo.sh
nano /usr/local/bin/himorogi.sh
cat /usr/local/bin/himorogi.sh
cat > /usr/local/bin/himorogi.sh <<'EOF'
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
EOF

chmod +x /usr/local/bin/himorogi.sh
cat > /usr/local/bin/wipe <<'EOF'
#!/bin/bash
exec /usr/local/bin/wipe_and_exit.sh
EOF

chmod +x /usr/local/bin/wipe
echo "alias wipe='/usr/local/bin/wipe'" > /etc/profile.d/99-wipe-alias.sh
cat /usr/local/bin/himorogi.sh
update-initramfs -u
exit
