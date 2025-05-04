#!/usr/bin/env bash
set -euo pipefail

# build_iso.sh – rebuild Himorogi live ISO end-to-end
# ---------------------------------------------------
# 1. Clean previous squashfs and ISO outputs
# 2. Copy kernel and initrd from chroot to iso/live
# 3. Create squashfs excluding pseudo-filesystems
# 4. Fix ownership and permissions
# 5. Build bootable hybrid ISO with xorriso
# 6. Verify /live exists inside ISO

BUILDROOT="$(pwd)"
CHROOT="$BUILDROOT/chroot"
ISODIR="$BUILDROOT/iso"
LIVEDIR="$ISODIR/live"
OUTISO="$BUILDROOT/himorogi-fixed.iso"

# Step 1: Clean existing outputs
echo "Step 1: Cleaning previous outputs..."
rm -f "$LIVEDIR/filesyst.squashfs" "$LIVEDIR/filesystem.squashfs" "$LIVEDIR/vmlinuz" "$LIVEDIR/initrd.img" "$OUTISO"

# Step 2: Prepare live/ directory
echo "Step 2: Preparing live/..."
mkdir -p "$LIVEDIR"
KVER=$(ls "$CHROOT/boot/vmlinuz-"* | sort -V | tail -n1 | sed 's|.*vmlinuz-||')
cp -f "$CHROOT/boot/vmlinuz-$KVER" "$LIVEDIR/vmlinuz"
cp -f "$CHROOT/boot/initrd.img-$KVER" "$LIVEDIR/initrd.img"
echo "✔ Copied vmlinuz-$KVER and initrd.img-$KVER as lowercase ISO-safe names"

# Step 2.5: Ensure critical empty mount-points exist
echo "Step 2.5: Ensuring empty pseudo-filesystem directories exist..."
for d in dev proc sys run tmp; do
  mkdir -p "$CHROOT/$d"
done

# Step 3: Create squashfs safely
echo "Step 3: Creating filesystem.squashfs with refined excludes..."
mksquashfs "$CHROOT" "$LIVEDIR/filesystem.squashfs" \
  -noappend \
  -wildcards \
  -e boot \
  -e proc/* \
  -e sys/* \
  -e dev/* \
  -e run/* \
  -e tmp/* \
  -e mnt/* \
  -e media/* \
  -e lost+found \
  -e var/cache/apt/archives/*.deb \
  -e var/tmp/* \
  -e var/lib/dbus/machine-id \
  -e root/.bash_history \
  -e home/*/.bash_history

# Step 4: Verify contents before ISO creation
echo "Step 4: Verifying live/ contents..."
for f in vmlinuz initrd.img filesystem.squashfs; do
  if [[ ! -f "$LIVEDIR/$f" ]]; then
    echo "❌ Error: $f missing in $LIVEDIR"
    exit 1
  fi
done
echo "✔ All expected files exist in $LIVEDIR"

# Step 5: Fix ownership and permissions
echo "Step 5: Fixing permissions..."
sudo chown -R root:root "$ISODIR"
sudo find "$ISODIR" -type d -exec chmod 755 {} +
sudo find "$ISODIR" -type f -exec chmod 644 {} +

# Debugging: Check ISODIR contents
echo "Contents of $ISODIR before ISO build:"
ls -lR "$ISODIR"

# Step 6: Build the ISO with xorriso (hybrid boot enabled, BIOS + UEFI)
echo "Step 6: Building ISO using xorriso -as mkisofs..."
sudo xorriso -as mkisofs \
  -o "$OUTISO" \
  -V "HIMOROGI_LIVE" \
  -R -J -l -iso-level 3 \
  -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin \
  -c isolinux/boot.cat \
  -b isolinux/isolinux.bin \
    -no-emul-boot -boot-load-size 4 -boot-info-table \
  -eltorito-alt-boot \
  -e isolinux/efiboot.img \
    -no-emul-boot \
  -isohybrid-gpt-basdat \
  "$ISODIR"

# Debugging: Check ISO contents
echo "Listing ISO contents:"
isoinfo -i "$OUTISO" -R -f

# Step 7: Confirm /live is in the ISO
echo "Step 7: Verifying /live in final ISO..."
if isoinfo -i "$OUTISO" -R -f | grep -q '^/live'; then
  echo "✔ ISO built successfully at $OUTISO"
else
  echo "❌ Error: /live directory NOT found in ISO. Build likely failed."
  echo "Try inspecting ISO contents manually with:"
  echo "  isoinfo -i \"$OUTISO\" -R -l"
  exit 1
fi
