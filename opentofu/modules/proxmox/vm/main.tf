terraform {
  required_providers {
   proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.90.0"
    }
  }
}

resource "proxmox_virtual_environment_file" "user_data" {
  content_type = "snippets"
  datastore_id = "local"
  node_name    = var.pve_node

  source_raw {
    data = <<EOF
#cloud-config
hostname: ${var.hostname}
user: ${var.username}
ssh_authorized_keys:
  - ${file(var.public_ssh_key)}
sudo: ALL=(ALL) NOPASSWD:ALL
packages:
  - qemu-guest-agent

# Ensure the root partition and filesystem expand to fill the available disk space
growpart:
  mode: auto
  devices: ['/']
  ignore_growpart_errors: false

resize_rootfs: true

runcmd:
  - systemctl enable --now qemu-guest-agent
EOF

    file_name = "${var.vm_name}-cloud-config.yaml"
  }
}

resource "proxmox_virtual_environment_vm" "vm" {
  name      = var.vm_name
  node_name = var.pve_node
  vm_id     = var.vm_id

  scsi_hardware = "virtio-scsi-single"

  operating_system {
    type = "l26"
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory
  }

  disk {
    datastore_id = var.storage
    interface    = "scsi0"
    size         = var.size
    discard      = "on"
  }

  network_device {
    bridge = "vmbr0"
    vlan_id = var.vlan_id
  }

  agent {
    enabled = true
    timeout = "2m"
  }

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.user_data.id
    interface = "ide2"

    dns {
      servers = var.nameservers
      domain  = var.searchdomain
    }

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.ipv4_gateway
      }
      ipv6 {
        address = var.ipv6_address
        gateway = var.ipv6_gateway
      }
    }
  }

  clone {
    vm_id = var.template_id
  }
}
