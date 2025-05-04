#!/bin/bash
echo "Verifying generated initramfs..."
INITRD_FILE=$(sudo ls -t chroot/boot/initrd.img-* | head -n 1)
if [ -f "$INITRD_FILE" ]; then
  echo "Checking $INITRD_FILE for live scripts..."
  TEMP_INITRD_DIR=$(mktemp -d)
  sudo cp "$INITRD_FILE" "$TEMP_INITRD_DIR/initrd.img"
  cd "$TEMP_INITRD_DIR"
  gunzip -c initrd.img | cpio -i -d -H newc --no-absolute-filenames > /dev/null 2>&1
  if [ -d "scripts/live" ]; then
    echo "OK: 'scripts/live' directory found in initramfs."
  else
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
    echo "ERROR: 'scripts/live' directory NOT FOUND in generated initramfs!"
    echo "The initramfs build likely failed. Check errors during Step 10."
    echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
  fi
  cd - # Go back to original directory
  sudo rm -rf "$TEMP_INITRD_DIR"
else
  echo "Warning: Could not find generated initrd file in chroot/boot/ to verify."
fi
#!/usr/bin/env bash
set -e

echo "Verifying generated initramfs..."

INITRD_FILE=$(ls -1t chroot/boot/initrd.img-* 2>/dev/null | head -n1)

if [[ -z "$INITRD_FILE" ]]; then
    echo "ERROR: No initrd images found in chroot/boot/"
    exit 1
fi

echo "Checking $INITRD_FILE for live scripts…"

# No need to decompress ­– just list its table of contents
if lsinitramfs "$INITRD_FILE" | grep -q '^scripts/live'; then
    echo "✓ OK: scripts/live found inside initramfs."
else
    echo "✗ ERROR: scripts/live NOT present in $INITRD_FILE"
    echo "  The live‑boot hook didn’t run. Reinstall live‑boot and"
    echo "  run: update-initramfs -c -k all  inside the chroot."
    exit 1
fi
