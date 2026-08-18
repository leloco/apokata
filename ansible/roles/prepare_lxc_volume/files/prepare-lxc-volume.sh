#!/usr/bin/env bash

# ==============================================================================
# Script: prepare-lxc-volume.sh
# Purpose: Pre-provisions independent LVM-Thin volumes for unprivileged LXC containers.
#          By naming the volume without '-disk-', Proxmox VE does not treat it as an
#          owned root disk. This ensures persistent application data is preserved
#          even when the LXC container is destroyed and recreated via IaC (OpenTofu).
# ==============================================================================

set -euo pipefail

# Parameter evaluation
VMID="${1:-}"
SIZE="${2:-}"
VG="${3:-pve}"

if [[ -z "$VMID" || -z "$SIZE" ]]; then
    echo "Usage: $0 <VMID> <SIZE_GB> [VOLUME_GROUP]"
    echo "Example: $0 206 10"
    echo "Resulting volume name: vm-206-data"
    exit 1
fi

LV_NAME="vm-${VMID}-data"
LV_PATH="/dev/${VG}/${LV_NAME}"
MOUNT_POINT="/mnt/prep-${LV_NAME}"

echo "==> 1. Creating LVM-Thin volume: ${LV_NAME} (${SIZE}G) in ${VG}/data..."
lvcreate -V "${SIZE}G" -n "${LV_NAME}" "${VG}/data"

echo "==> 2. Formatting volume as Ext4..."
mkfs.ext4 -q "${LV_PATH}"

echo "==> 3. Adjusting ownership for unprivileged LXC (Sub-UID 100000)..."
mkdir -p "${MOUNT_POINT}"
mount "${LV_PATH}" "${MOUNT_POINT}"

# Set ownership to unprivileged LXC root (mapped to host UID 100000)
chown -R 100000:100000 "${MOUNT_POINT}"

echo "==> 4. Cleaning up mount point..."
umount "${MOUNT_POINT}"
rmdir "${MOUNT_POINT}"

echo "--------------------------------------------------------"
echo "SUCCESS: Volume ${LV_NAME} prepared successfully!"
echo "Reference it in your OpenTofu configuration as follows:"
echo ""
echo "mount_points = ["
echo "  {"
echo "    volume = \"local-lvm:${LV_NAME}\""
echo "    path   = \"/opt/data\""
echo "    size   = \"${SIZE}G\""
echo "    backup = true"
echo "  }"
echo "]"
echo ""
echo "--------------------------------------------------------"
echo "NOTE ON EXPANDING CAPACITY LATER:"
echo "1. Expand LVM volume and filesystem online on Proxmox host:"
echo "   lvextend -r -L +<ADDITIONAL_GB>G ${LV_PATH}"
echo ""
echo "2. Update the 'size' property in your OpenTofu configuration (.tf)"
echo "   to match the new total size and keep state in sync."
echo "--------------------------------------------------------"
