#!/bin/bash

ISO_FILE="himorogi-fixed.iso"

echo "🔍 Verifying ISO image: $ISO_FILE"
echo "-------------------------------"

# Check if ISO exists
if [ ! -f "$ISO_FILE" ]; then
  echo "❌ ISO file not found: $ISO_FILE"
  exit 1
fi

# Check file is readable
echo "✅ Checking file readability..."
if ! sha256sum "$ISO_FILE" >/dev/null; then
  echo "❌ Failed to read ISO file (possible corruption or I/O error)."
  exit 1
fi

# Check if isoinfo is installed
if ! command -v isoinfo >/dev/null; then
  echo "❌ 'isoinfo' not found. Please run: sudo apt install genisoimage"
  exit 1
fi

# Check volume structure
echo "✅ Listing ISO contents..."
MISSING=0
for FILE in /live/vmlinuz /live/initrd.img /live/filesystem.squashfs; do
  if isoinfo -i "$ISO_FILE" -f 2>/dev/null | grep -q "$FILE"; then
    echo "✅ Found: $FILE"
  else
    echo "❌ Missing: $FILE"
    MISSING=1
  fi
done

echo "-------------------------------"
if [ "$MISSING" -eq 0 ]; then
  echo "🎉 All required live-boot files are present!"
else
  echo "⚠️ Some required files are missing. Live-boot may fail."
fi
