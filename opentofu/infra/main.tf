locals {
  _networks = {
    trusted = var.infra_trusted_cidr
    core = var.infra_core_cidr
    iot = var.infra_iot_cidr
    lab = var.infra_lab_cidr
    guest = var.infra_guest_cidr
    work = var.infra_work_cidr
  }

  _ula_prefixes = {
    trusted = var.infra_trusted_prefix
    core = var.infra_core_prefix
    iot = var.infra_iot_prefix
    lab = var.infra_lab_prefix
    guest = var.infra_guest_prefix
    work = var.infra_work_prefix
  }

  vlans = {
    trusted = {
      id      = var.infra_trusted_vlan_id
      network = local._networks.trusted
      gateway_ipv4 = cidrhost(local._networks.trusted, var.infra_trusted_gateway_host_id)
      ula_prefix   = local._ula_prefixes.trusted
      gateway_ipv6 = "${local._ula_prefixes.trusted}${var.infra_trusted_gateway_iid}"
    }

    core = {
      id      = var.infra_core_vlan_id
      network = local._networks.core
      gateway_ipv4 = cidrhost(local._networks.core, var.infra_core_gateway_host_id)
      ula_prefix   = local._ula_prefixes.core
      gateway_ipv6 = "${local._ula_prefixes.core}${var.infra_core_gateway_iid}"
    }

    iot = {
      id      = var.infra_iot_vlan_id
      network = local._networks.iot
      gateway_ipv4 = cidrhost(local._networks.iot, var.infra_iot_gateway_host_id)
      ula_prefix   = local._ula_prefixes.iot
      gateway_ipv6 = "${local._ula_prefixes.iot}${var.infra_iot_gateway_iid}"
    }

    lab = {
      id      = var.infra_lab_vlan_id
      network = local._networks.lab
      gateway_ipv4 = cidrhost(local._networks.lab, var.infra_lab_gateway_host_id)
      ula_prefix   = local._ula_prefixes.lab
      gateway_ipv6 = "${local._ula_prefixes.lab}${var.infra_lab_gateway_iid}"
    }

    guest = {
      id      = var.infra_guest_vlan_id
      network = local._networks.guest
      gateway_ipv4 = cidrhost(local._networks.guest, var.infra_guest_gateway_host_id)
      ula_prefix   = local._ula_prefixes.guest
      gateway_ipv6 = "${local._ula_prefixes.guest}${var.infra_guest_gateway_iid}"
    }

    work = {
      id      = var.infra_work_vlan_id
      network = local._networks.work
      gateway_ipv4 = cidrhost(local._networks.work, var.infra_work_gateway_host_id)
      ula_prefix   = local._ula_prefixes.work
      gateway_ipv6 = "${local._ula_prefixes.work}${var.infra_work_gateway_iid}"
    }
  }

  # Fully managed means automatically created with IaC (OpenTofu) and / or configured with CaC (Ansible)
  # Semi managed means the host was created manually but is configured CaC
  # Unmanaged means everything is configured manually

  fully_managed_hosts = {
    # ----------------------- WARNING -------------------------
    # Runners are primarily configured in /runner where their configuration actually live. Changes here require changes inside /runner and vice versa.
    # ---------------------------------------------------------
    runner_alpha = {
       hostname = "runner-alpha"
       ipv4_address = cidrhost(local.vlans.lab.network, var.infra_runner_alpha_host_id)
       ipv6_address = "${local.vlans.lab.ula_prefix}${var.infra_runner_alpha_iid}"
       user = var.infra_runner_alpha_user
    }
    # ---------------------------------------------------------

    tang = {
       hostname = "tang"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_tang_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_tang_iid}"
    }

    prowl = {
       hostname = "prowl"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_prowl_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_prowl_iid}"
    }

    unifi_controller = {
       hostname = "unifi-controller"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_unifi_controller_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_unifi_controller_iid}"
    }
  }

  semi_managed_hosts = {
    shadow = {
       hostname = "shadow"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_shadow_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_shadow_iid}"
       user = var.infra_shadow_user
    }

    sentinel = {
      hostname = "sentinel"
      ipv4_address = var.infra_sentinel_ipv4
    }

    ninja = {
      hostname = "ninja"
      ipv4_address = cidrhost(local.vlans.core.network, var.infra_ninja_host_id)
      ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_ninja_iid}"
    }
  }

  unmanaged_hosts = {
      ironhide = {
       hostname = "ironhide"
       ipv4_address = cidrhost(local.vlans.trusted.network, var.infra_ironhide_host_id)
       ipv6_address = "${local.vlans.trusted.ula_prefix}${var.infra_ironhide_iid}"
      }
  }

  virtual = {
    ipv4_address = cidrhost(local.vlans.core.network, var.infra_vip_host_id)
    ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_vip_iid}"
  }
}

resource "local_file" "ansible_inventory" {
  filename = "../../ansible/inventory.ini"
  content  = <<EOT
# ----------------------- WARNING -------------------------
# THIS FILE IS AUTOGENERATED BY OPENTOFU (/opentofu/infra/main.tf)
# Any manual changes to this file will be overwritten during the next run of tofu apply.
# Generated on: ${timestamp()}
# ---------------------------------------------------------
[proxmox_ve]
${local.semi_managed_hosts.ninja.hostname} ansible_host=${local.semi_managed_hosts.ninja.ipv4_address}

[proxmox_bs]
${local.semi_managed_hosts.sentinel.hostname} ansible_host=${local.semi_managed_hosts.sentinel.ipv4_address}

[proxmox_lxc]
${local.fully_managed_hosts.tang.hostname} ansible_host=${local.fully_managed_hosts.tang.ipv4_address}
${local.fully_managed_hosts.prowl.hostname} ansible_host=${local.fully_managed_hosts.prowl.ipv4_address} ansible_host_ipv6=${local.fully_managed_hosts.prowl.ipv6_address}
${local.fully_managed_hosts.unifi_controller.hostname} ansible_host=${local.fully_managed_hosts.unifi_controller.ipv4_address} ansible_host_ipv6=${local.fully_managed_hosts.unifi_controller.ipv6_address}

[proxmox_vm]
${local.fully_managed_hosts.runner_alpha.hostname} ansible_host=${local.fully_managed_hosts.runner_alpha.ipv4_address}  ansible_user=${local.fully_managed_hosts.runner_alpha.user}

[dns_group]
${local.semi_managed_hosts.shadow.hostname} ansible_host=${local.semi_managed_hosts.shadow.ipv4_address} ansible_host_ipv6=${local.semi_managed_hosts.shadow.ipv6_address} keepalived_role=MASTER keepalived_priority=100 ansible_user=${local.semi_managed_hosts.shadow.user}
${local.fully_managed_hosts.prowl.hostname} keepalived_role=BACKUP keepalived_priority=80

[dns_group:vars]
network_interface=eth0

[tang_group]
${local.fully_managed_hosts.tang.hostname}

[runner_group]
${local.fully_managed_hosts.runner_alpha.hostname}

[unifi_group]
${local.fully_managed_hosts.unifi_controller.hostname}

[all:children]
proxmox_ve
proxmox_bs
proxmox_lxc
proxmox_vm
tang_group
runner_group
dns_group
unifi_group

[all:vars]
dns_gateway_ipv4=${local.vlans.core.gateway_ipv4}
dns_gateway_ipv6=${local.vlans.core.gateway_ipv6}
custom_domain=x3dh.de
virtual_ipv4=${local.virtual.ipv4_address}
virtual_ipv6=${local.virtual.ipv6_address}
# ansible settings
ansible_user=root
# configured with ssh-agent
ansible_ssh_trusted_key_file=""
ansible_ssh_common_args='-o StrictHostKeyChecking=no'
EOT

depends_on = [ module.tang, module.prowl, module.unifi_controller ]
}

resource "proxmox_virtual_environment_dns" "node_dns" {
  node_name = local.semi_managed_hosts.ninja.hostname
  servers = [local.virtual.ipv4_address, local.virtual.ipv6_address, local.vlans.core.gateway_ipv4]
  domain  = var.shared_searchdomain
}

module "tang" {
  source = "../modules/proxmox/lxc"

  pve_node         = var.shared_pve_node
  vm_id            = 200
  hostname         = local.fully_managed_hosts.tang.hostname

  nameservers       = [local.virtual.ipv4_address, local.virtual.ipv6_address, local.vlans.core.gateway_ipv4, local.vlans.core.gateway_ipv6]
  searchdomain     = var.shared_searchdomain

  vlan_id          = local.vlans.core.id
  template_file_id = var.shared_lxc_template_file_id

  ipv4_address     = "${local.fully_managed_hosts.tang.ipv4_address}/24"
  gateway          = local.vlans.core.gateway_ipv4

  ipv6_address     = "${local.fully_managed_hosts.tang.ipv6_address}/64"
  ipv6_gateway     = local.vlans.core.gateway_ipv6

  ssh_public_key_file = var.shared_ssh_public_key_file

  datastore_id     = var.shared_root_datastore_id
  datastore_size   = var.shared_small_root_datastore_size
  start_on_boot    = var.shared_start_on_boot
}

module "prowl" {
  source = "../modules/proxmox/lxc"

  pve_node         = var.shared_pve_node
  vm_id            = 201
  hostname         = local.fully_managed_hosts.prowl.hostname
  nameservers       = [local.virtual.ipv4_address, local.virtual.ipv6_address, local.vlans.core.gateway_ipv4, local.vlans.core.gateway_ipv6]
  searchdomain     = var.shared_searchdomain

  vlan_id          = local.vlans.core.id
  template_file_id = var.shared_lxc_template_file_id

  ipv4_address     = "${local.fully_managed_hosts.prowl.ipv4_address}/24"
  gateway          = local.vlans.core.gateway_ipv4

  ipv6_address     = "${local.fully_managed_hosts.prowl.ipv6_address}/64"
  ipv6_gateway     = local.vlans.core.gateway_ipv6

  ssh_public_key_file = var.shared_ssh_public_key_file

  datastore_id     = var.shared_root_datastore_id
  datastore_size   = var.shared_small_root_datastore_size
  start_on_boot    = var.shared_start_on_boot
}


module "unifi_controller" {
  source = "../modules/proxmox/lxc"

  pve_node         = var.shared_pve_node
  vm_id            = 203
  hostname         = local.fully_managed_hosts.unifi_controller.hostname
  nameservers       = [local.virtual.ipv4_address, local.virtual.ipv6_address, local.vlans.core.gateway_ipv4, local.vlans.core.gateway_ipv6]
  searchdomain     = var.shared_searchdomain

  memory_dedicated = 2048
  memory_swap      = 1024
  cpu_cores        = 2

  vlan_id          = local.vlans.core.id
  template_file_id = var.shared_lxc_template_file_id

  ipv4_address     = "${local.fully_managed_hosts.unifi_controller.ipv4_address}/24"
  gateway          = local.vlans.core.gateway_ipv4

  ipv6_address     = "${local.fully_managed_hosts.unifi_controller.ipv6_address}/64"
  ipv6_gateway     = local.vlans.core.gateway_ipv6

  ssh_public_key_file = var.shared_ssh_public_key_file

  datastore_id     = var.shared_root_datastore_id
  datastore_size   = var.shared_medium_root_datastore_size
  start_on_boot    = var.shared_start_on_boot
}

resource "proxmox_virtual_environment_storage_pbs" "pbs_backup" {
  id          = "backups"
  nodes       = ["ninja"]
  server      = local.semi_managed_hosts.sentinel.ipv4_address
  datastore   = "backups"
  username       = var.pbs_username
  password       = var.pbs_password
  fingerprint    = var.pbs_fingerprint
  encryption_key = var.pbs_encryption_key_data
  content = ["backup"]
}

resource "proxmox_backup_job" "daily_pbs_backup" {
  id       = "daily-pbs-backup"
  enabled  = true
  schedule = "23:00"
  storage  = proxmox_virtual_environment_storage_pbs.pbs_backup.id

  all = true
  mode = "stop"
  notes_template = "{{guestname}} backup"
  prune_backups = {
    "keep-last"    = "7"
    "keep-daily"   = "30"
    "keep-monthly" = "6"
  }
  mailto = var.backup_notification_email
}
