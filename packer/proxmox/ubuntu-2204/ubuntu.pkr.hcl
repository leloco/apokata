packer {
  required_plugins {
    proxmox = {
      version = ">= 1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "ubuntu" {
  proxmox_url              = "${var.shared_pve_endpoint}/api2/json"
  username                 = split("=", var.shared_pve_api_token)[0]
  token                    = split("=", var.shared_pve_api_token)[1]
  insecure_skip_tls_verify = true

  node                     = var.target_node
  vm_id                     = var.template_id
  vm_name                   = var.template_name
  template_description     = "Automated Packer Build: Ubuntu 22.04 LTS"

  iso_url              = "https://releases.ubuntu.com/jammy/ubuntu-22.04.5-live-server-amd64.iso"
  iso_checksum         = "file:https://releases.ubuntu.com/jammy/SHA256SUMS"
  iso_storage_pool     = "local"
  unmount_iso          = true

  qemu_agent           = true
  cores                = 2
  memory               = 2048
  os                   = "l26"
  scsi_controller      = "virtio-scsi-pci"

  disks {
    disk_size         = "20G"
    format            = "raw"
    storage_pool      = "local-lvm"
    type              = "scsi"
  }

  vga {
    type   = "std"
    memory = 16
  }

  network_adapters {
    bridge = "vmbr0"
    model  = "virtio"
    vlan_tag = "22"
  }

  http_directory = "http"
  http_bind_address = "0.0.0.0"

  boot_wait = "8s"
  boot_keygroup_interval   = "100ms"

  boot_command = [
  "c<wait5>",
  "linux /casper/vmlinuz quiet autoinstall ds='nocloud-net;s=http://{{ .HTTPIP }}:{{ .HTTPPort }}/' ---<enter><wait2>",
  "initrd /casper/initrd<enter><wait2>",
  "boot<enter>"
  ]

  ssh_username         = "ubuntu"
  ssh_private_key_file = pathexpand(var.ssh_private_key_file)
  ssh_timeout          = "20m"
}


build {
  sources = ["source.proxmox-iso.ubuntu"]

  # Install QEMU Guest Agent
  provisioner "shell" {
    inline = [
      "echo '==> Updating package repository cache...'",
      "sudo apt-get update -y",

      "echo '==> Upgrading packages...'",
      "sudo apt-get upgrade -y",

      "echo '==> Installing QEMU Guest Agent...'",
      "sudo apt-get install -y qemu-guest-agent",
      # qemu-guest-agent will be automatically started by udev
    ]
  }

  # Sysprep
  provisioner "shell" {
    inline = [
      "echo '==> Cleaning cloud-init cache and logs...'",
      "sudo cloud-init clean --logs --seed",

      "echo '==> Resetting system machine-id...'",
      "sudo truncate -s 0 /etc/machine-id",
      "sudo rm -f /var/lib/dbus/machine-id",
      "sudo ln -s /etc/machine-id /var/lib/dbus/machine-id",

      "echo '==> Purging temporary SSH host keys...'",
      "sudo rm -f /etc/ssh/ssh_host_*",

      "echo '==> Pruning APT packages and temporary files...'",
      "sudo apt-get autoremove -y",
      "sudo apt-get clean"
    ]
  }
}
