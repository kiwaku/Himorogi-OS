#!/bin/bash
echo "Available block devices (potential USB drives):"
lsblk -d -o NAME,SIZE,MODEL | grep -vE 'loop|sr|nvme|sda$' # Basic filter
echo ""
read -p "Enter device NAME to mount (e.g., sdb1, sdc1): " dev
if [ -z "$dev" ]; then
  echo "No device entered. Exiting."
  exit 1
fi
if [ ! -b "/dev/$dev" ]; then
  echo "Error: Device /dev/$dev not found or is not a block device."
  exit 1
fi
# Try mounting common filesystems
MOUNT_POINT="/mnt/usb_$(basename $dev)"
mkdir -p "$MOUNT_POINT"
echo "Attempting to mount /dev/$dev at $MOUNT_POINT..."
if mount -o ro "/dev/$dev" "$MOUNT_POINT"; then # Mount read-only first
  echo "Successfully mounted /dev/$dev (read-only) at $MOUNT_POINT"
  echo "Filesystem type: $(lsblk -f -n -o FSTYPE /dev/$dev)"
  echo "To unmount: sudo umount $MOUNT_POINT"
elif mount -t ntfs-3g -o ro "/dev/$dev" "$MOUNT_POINT"; then # Try NTFS
  echo "Successfully mounted /dev/$dev (NTFS, read-only) at $MOUNT_POINT"
  echo "To unmount: sudo umount $MOUNT_POINT"
else
   echo "Error mounting /dev/$dev. Common filesystem types (ext4, vfat, ntfs) failed or device is already mounted."
   rmdir "$MOUNT_POINT" 2>/dev/null
   exit 1
fi
read -p "Mount read-write? (Requires filesystem support) [y/N]: " remount_rw
if [[ "$remount_rw" =~ ^[Yy]$ ]]; then
  if umount "$MOUNT_POINT" && mount "/dev/$dev" "$MOUNT_POINT"; then
    echo "Remounted read-write at $MOUNT_POINT."
  else
    echo "Failed to remount read-write. Keeping read-only mount."
    # Re-attempt read-only mount just in case
    mount -o ro "/dev/$dev" "$MOUNT_POINT" 2>/dev/null || mount -t ntfs-3g -o ro "/dev/$dev" "$MOUNT_POINT" 2>/dev/null
  fi
fi
