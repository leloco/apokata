resource "local_file" "ansible_inventory" {
  filename = "./ansible/inventory.ini"
  content  = <<EOT
[proxmox_lxc]
${proxmox_virtual_environment_container.tang.initialization[0].hostname} ansible_host=${split("/", proxmox_virtual_environment_container.tang.initialization[0].ip_config[0].ipv4[0].address)[0]}

${proxmox_virtual_environment_container.ops.initialization[0].hostname} ansible_host=${split("/", proxmox_virtual_environment_container.ops.initialization[0].ip_config[0].ipv4[0].address)[0]}

[tang_group]
${proxmox_virtual_environment_container.tang.initialization[0].hostname}

[tang_group:vars]
tang_subnet=${var.network_subnet}

[ops_group]
${proxmox_virtual_environment_container.ops.initialization[0].hostname}

[all:children]
proxmox_lxc
tang_group
ops_group

[all:vars]
ansible_user=root
ansible_ssh_private_key_file=${replace(var.ssh_public_key_file, ".pub", "")}
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT

depends_on = [ proxmox_virtual_environment_container.tang, proxmox_virtual_environment_container.ops ]
}

resource "proxmox_virtual_environment_container" "ops" {
  description = "Managed by OpenTofu"
  node_name   = "ninja"
  vm_id       = 201
  unprivileged = true
  
  operating_system {
    template_file_id = var.debian_template_file_id
    type             = "debian"
  }

  initialization {
    hostname = "ops"

    ip_config {
      ipv4 {
        address = var.ninja_ops_ipv4
        gateway = var.network_gateway
      }

      ipv6 {
        address = "auto"  # "auto" activates SLAAC
      }
    }

    user_account {
      keys = [
        trimspace(file(var.ssh_public_key_file))
      ]
      password = var.ops_root_password
    }
  }

  network_interface {
    name = "eth0"
    bridge = var.network_bridge
  }

  cpu {
    cores = 2
  }

  memory {
    dedicated = 2048
    swap      = 1024
  }

  disk {
    datastore_id = var.datastore_zfs
    size         = 4
  }

  mount_point {
    volume = "wd-red-plus-1"
    path  = "/mnt/tank" 
    size    = "10G"   
    backup  = true 
  }

  features {
    nesting = true
  }

  start_on_boot = true
  started = true
}

resource "proxmox_virtual_environment_container" "tang" {
  description = "Managed by OpenTofu"
  node_name   = "ninja"
  vm_id       = 200    
  unprivileged = true

  operating_system {
    template_file_id = var.debian_template_file_id
    type             = "debian"
  }

  initialization {
    hostname = "tang"

    ip_config {
      ipv4 {
        address = var.ninja_tang_ipv4
        gateway = var.network_gateway 
      }

      ipv6 {
        address = "auto"  # "auto" activates SLAAC
      }
    }

    user_account {
      keys = [
        trimspace(file(var.ssh_public_key_file))
      ]
      password = var.tang_root_password
    }
  }

  network_interface {
    name = "eth0"
    bridge = var.network_bridge 
  }

  cpu {
    cores = 1
  }

  memory {
    dedicated = 512
    swap      = 512
  }

  disk {
    datastore_id = var.datastore_zfs
    size         = 4
  }

  start_on_boot = true
  started = true
}
