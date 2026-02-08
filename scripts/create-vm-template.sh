#!/bin/bash

# Where to run: Proxmox host 

VM_ID=9000
VM_NAME="ubuntu-22-04-template"
STORAGE="local-lvm" # Dein Proxmox Storage Name
IMAGE_URL="https://cloud-images.ubuntu.com/jammy/current/jammy-server-cloudimg-amd64.img"
IMAGE_NAME="jammy-server-cloudimg-amd64.img"

# destroy old template
qm destroy $VM_ID --purge 2>/dev/null

# download the image
if [ ! -f "$IMAGE_NAME" ]; then
    wget $IMAGE_URL
fi

# create the vm
qm create $VM_ID --name $VM_NAME --memory 2048 --net0 virtio,bridge=vmbr0

# import the image (creates a virtual disk)
qm importdisk $VM_ID $IMAGE_NAME $STORAGE

# connect disk to the vm
qm set $VM_ID --scsihw virtio-scsi-pci --scsi0 $STORAGE:vm-$VM_ID-disk-0

# add cloud-init drive
qm set $VM_ID --ide2 $STORAGE:cloudinit

# configure boot order
qm set $VM_ID --boot c --bootdisk scsi0

# configure serial (console for cloud-init output)
qm set $VM_ID --serial0 socket --vga serial0

# convert to template
qm template $VM_ID

echo "OK. $VM_NAME ($VM_ID)"
