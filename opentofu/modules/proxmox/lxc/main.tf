terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">= 0.90.0"
    }
  }
}

resource "proxmox_virtual_environment_container" "lxc" {
  description = "Managed by OpenTofu"
  node_name   = var.pve_node
  vm_id = var.vm_id
  unprivileged = true

  operating_system {
    template_file_id = var.template_file_id
    type             = var.template_type
  }

  initialization {
    hostname = var.hostname

    ip_config {
      ipv4 {
        address = var.ipv4_address
        gateway = var.gateway
      }

      ipv6 {
        address = var.ipv6_address
        gateway = var.ipv6_gateway
      }
    }

    user_account {
      keys = [
        trimspace(file(var.ssh_public_key_file))
      ]
      password = var.root_password
    }
  }

  features {
    nesting = var.nesting
  }

  network_interface {
    name = "eth0"
    bridge = var.network_bridge
  }

  cpu {
    cores = var.cpu_cores
  }

  memory {
    dedicated = var.memory_dedicated
    swap      = var.memory_swap
  }

  disk {
    datastore_id = var.datastore_id
    size         = var.datastore_size
  }


  start_on_boot = var.start_on_boot
  started = true
}

