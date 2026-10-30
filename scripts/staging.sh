#!/usr/bin/bash
set -euo pipefail

VM_ID=101
SNAPSHOT="v5"
VM="shockwave.pve.internal"
PROXMOX_HOST="root@primus.pve.internal"
LOCK_DIR="/var/lock/apokata_staging_${VM_ID}.lock"

echo "Acquiring deployment lock on Proxmox..."

if ! ssh "$PROXMOX_HOST" "mkdir $LOCK_DIR" 2>/dev/null; then
    echo "ERROR: Staging environment is locked! GitHub Actions or another process is currently running."
    exit 1
fi

trap 'echo "Releasing deployment lock..."; ssh "$PROXMOX_HOST" "rmdir $LOCK_DIR"' EXIT

echo "Rolling back VM $VM_ID to snapshot '$SNAPSHOT'..."
ssh "$PROXMOX_HOST" "qm rollback ${VM_ID} ${SNAPSHOT}"

echo "Starting VM $VM_ID..."
ssh "$PROXMOX_HOST" "qm start ${VM_ID}" || true

echo "Waiting for SSH on $VM:22..."
while ! nc -z -w5 "$VM" 22 2>/dev/null; do
  sleep 2
done

echo "Staging env ready."
