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
    timeout = "0s"
  }

  initialization {
    user_data_file_id = proxmox_virtual_environment_file.user_data.id
    interface = "scsi1"
    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.gateway
      }
      ipv6 {
        address = "dhcp"
      }
    }
  }

  clone {
    vm_id = var.template_id
  }
}
