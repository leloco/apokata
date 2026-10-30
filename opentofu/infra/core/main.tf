locals {
  _networks = {
    trusted = var.infra_trusted_cidr
    core = var.infra_core_cidr
    iot = var.infra_iot_cidr
    lab = var.infra_lab_cidr
    staging = var.infra_staging_cidr
    guest = var.infra_guest_cidr
    work = var.infra_work_cidr
    # no vlan
    storage = var.infra_storage_cidr
  }

  _ula_prefixes = {
    trusted = var.infra_trusted_prefix
    core = var.infra_core_prefix
    iot = var.infra_iot_prefix
    lab = var.infra_lab_prefix
    staging = var.infra_staging_prefix
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

    staging = {
      id      = var.infra_staging_vlan_id
      network = local._networks.staging
      gateway_ipv4 = cidrhost(local._networks.staging, var.infra_staging_gateway_host_id)
      ula_prefix   = local._ula_prefixes.staging
      gateway_ipv6 = "${local._ula_prefixes.staging}${var.infra_staging_gateway_iid}"
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

  pve_nodes = {
    ninja = {
      hostname = "ninja"
      ipv4_address = cidrhost(local.vlans.core.network, var.infra_ninja_host_id)
      ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_ninja_iid}"
      template_id  = 9000
      enabled      = var.is_prod
      groups       = ["proxmox_servers"]
    }
    primus = {
      hostname = "primus"
      ipv4_address = cidrhost(local.vlans.core.network, var.infra_primus_host_id)
      ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_primus_iid}"
      template_id  = 9002
      enabled      = var.is_prod
      groups       = ["proxmox_servers"]
    }
    gnaw = {
      hostname = "gnaw"
      ipv4_address = cidrhost(local.vlans.core.network, var.infra_primus_host_id)
      ipv4_address = cidrhost(local.vlans.core.network, var.infra_gnaw_host_id)
      ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_gnaw_iid}"
      template_id  = 9001
      enabled      = var.is_prod
      groups       = ["proxmox_servers"]
    }
    # not managed by IaC nor CaC
    shockwave = {
      hostname = "shockwave"
      ipv4_address = cidrhost(local.vlans.core.network, var.infra_primus_host_id)
      ipv4_address = cidrhost(local.vlans.staging.network, var.infra_shockwave_host_id)
      ipv6_address = "${local.vlans.staging.ula_prefix}${var.infra_shockwave_iid}"
      template_id  = 9000
      enabled      = !var.is_prod
      groups       = ["proxmox_servers"]
    }
  }

  standalone_instances = {
    sentinel = {
      hostname = "sentinel"
      enabled = var.is_prod
      ipv4_address = var.infra_sentinel_ipv4
      groups       = ["proxmox_backup_servers"]
    }

    metroplex = {
      hostname = "metroplex"
      enabled = var.is_prod
      ipv4_address = var.is_prod ? cidrhost(local.vlans.core.network, var.infra_metroplex_host_id) : ""
      ipv6_address = var.is_prod ? "${local.vlans.core.ula_prefix}${var.infra_metroplex_iid}" : ""
      groups       = ["truenas_servers"]
    }

    ironhide = {
      hostname = "ironhide"
      enabled = var.is_prod
      ipv4_address = var.is_prod ? cidrhost(local.vlans.trusted.network, var.infra_ironhide_host_id) : ""
      ipv6_address = var.is_prod ? "${local.vlans.trusted.ula_prefix}${var.infra_ironhide_iid}" : ""
      groups       = ["local_servers"]
    }
  }

  k8s_nodes = {
    controlplane1 = {
      vm_id        = 210
      enabled      = var.is_prod
      on_boot      = true
      hostname = "cluster1-controlplane1"
      pve_node = var.is_prod ? "primus" : "shockwave"
      user         = var.infra_cluster1_controlplane1_user
      cpu_cores    = var.is_prod ? 4 : 2
      memory       = var.is_prod ? 8192 : 4096
      storage      = "local-lvm"
      size    = "20"
      ipv4_address = cidrhost(local.vlans.lab.network, var.infra_cluster1_controlplane1_host_id)
      ipv6_address = "${local.vlans.lab.ula_prefix}${var.infra_cluster1_controlplane1_iid}"
      bridge_storage = var.is_prod ? "vmbr1" : null
      template_id  = local.pve_nodes[var.is_prod ? "primus" : "shockwave"].template_id
      storage_ipv4_address = var.is_prod ? cidrhost(local._networks.storage, 80) : ""
      bridge_frontend = "vmbr0"
      os = "l26"
      groups       = ["proxmox_vms", "k8s_nodes", "k8s_cluster1_nodes", "k8s_cluster1_controlplanes"]
    }

    worker1 = {
      vm_id        = 211
      enabled      = var.is_prod
      on_boot      = true
      pve_node = var.is_prod ? "primus" : "shockwave"
      hostname     = "cluster1-worker1"
      user         = var.infra_cluster1_worker1_user
      cpu_cores    = var.is_prod ? 4 : 2
      memory       = var.is_prod ? 8192 : 4096
      storage      = "local-lvm"
      size    = "20"
      ipv4_address = cidrhost(local.vlans.lab.network, var.infra_cluster1_worker1_host_id)
      ipv6_address = "${local.vlans.lab.ula_prefix}${var.infra_cluster1_worker1_iid}"
      bridge_storage = var.is_prod ? "vmbr1" : null
      template_id  = local.pve_nodes[var.is_prod ? "primus" : "shockwave"].template_id
      storage_ipv4_address = var.is_prod ? cidrhost(local._networks.storage, 81) : ""
      bridge_frontend = "vmbr0"
      os = "l26"
      groups       = ["proxmox_vms", "k8s_nodes", "k8s_cluster1_nodes", "k8s_cluster1_controlplanes"]
    }
  }

  vm_instances = {
  }

  lxc_instances = {

    # ----------------------- TANG start -------------------------
    tang = {
       vm_id        = 200
       enabled      = var.is_prod
       hostname = "tang"
       pve_node = var.is_prod ? "ninja" : "shockwave"
       cpu_cores    = 1
       memory_dedicated = 256
       memory_swap = 256
       datastore_id     = "local-lvm"
       datastore_size   = "5"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_tang_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_tang_iid}"
       start_on_boot    = "true"
       mount_points    = []
       groups       = ["proxmox_lxcs", "tang_servers"]
    }
    # ----------------------- TANG end -------------------------

    # ----------------------- DNS start -------------------------
    prowl = {
       vm_id    = 201
       enabled = true
       pve_node = var.is_prod ? "ninja" : "shockwave"
       hostname = "prowl"
       cpu_cores    = 1
       memory_dedicated = 256
       memory_swap = 256
       datastore_id     = "local-lvm"
       datastore_size   = "5"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_prowl_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_prowl_iid}"
       start_on_boot    = "true"
       mount_points    = []
       groups       = ["proxmox_lxcs", "dns_servers"]
       extra_vars   = "keepalived_role=MASTER keepalived_priority=100"
    }

    hound = {
       vm_id    = 202
       enabled = true
       pve_node = var.is_prod ? "primus" : "shockwave"
       hostname = "hound"
       cpu_cores    = 1
       memory_dedicated = 256
       memory_swap = 256
       datastore_id     = "local-lvm"
       datastore_size   = "5"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_hound_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_hound_iid}"
       start_on_boot    = "true"
       mount_points    = []
       groups       = ["proxmox_lxcs", "dns_servers"]
       extra_vars   = "keepalived_role=BACKUP keepalived_priority=80"
    }

    blurr = {
       vm_id   = 203
       enabled = true
       pve_node = var.is_prod ? "gnaw" : "shockwave"
       hostname = "blurr"
       cpu_cores    = 1
       memory_dedicated = 256
       memory_swap = 256
       datastore_id     = "local-lvm"
       datastore_size   = "5"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_blurr_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_blurr_iid}"
       start_on_boot    = "true"
       mount_points    = []
       groups       = ["proxmox_lxcs", "dns_servers"]
       extra_vars   = "keepalived_role=BACKUP keepalived_priority=60"
    }
    # ----------------------- DNS end -------------------------

    # ----------------------- PROXY start -------------------------
    z1_npm = {
       vm_id = 204
       enabled = var.is_prod
       pve_node = "ninja"
       hostname = "z1-npm"
       cpu_cores    = 1
       memory_dedicated = 512
       memory_swap = 256
       datastore_id     = "local-lvm"
       datastore_size   = "10"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_z1_npm_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_z1_npm_iid}"
       start_on_boot    = "true"
       mount_points = var.is_prod ? [
        {
          volume = "local-lvm:vm-204-data"
          path   = "/opt/npm-data"
          size   = var.is_prod ? "2" : "1"
          backup = true
        }
        ] : []
       groups       = ["docker_hosts", "proxy_servers", "portainer_agents"]
    }
    # ----------------------- PROXY end -------------------------

    # ----------------------- CORE APPS start -------------------------
    z1_portainer = {
       vm_id = 205
       enabled = var.is_prod
       pve_node = var.is_prod ? "ninja" : "shockwave"
       hostname = "z1-portainer"
       cpu_cores    = 1
       memory_dedicated = 1024
       memory_swap = 256
       datastore_id     = "local-lvm"
       datastore_size   = "5"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_z1_portainer_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_z1_portainer_iid}"
       start_on_boot    = "true"
       mount_points = var.is_prod ? [
        {
          volume = "local-lvm:vm-205-data"
          path   = "/opt/portainer-data"
          size   = var.is_prod ? "8" : "4"
          backup = true
        }
        ] : []
       groups       = ["docker_hosts", "portainer_servers"]
    }

    z1_rocketchat = {
       vm_id = 206
       enabled = var.is_prod
       pve_node = var.is_prod ? "ninja" : "shockwave"
       hostname = "z1-rocketchat"
       cpu_cores    = 4
       memory_dedicated = 4096
       memory_swap = 2048
       datastore_id     = "local-lvm"
       datastore_size   = "20"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_z1_rocketchat_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_z1_rocketchat_iid}"
       start_on_boot    = "true"
       mount_points = var.is_prod ? [
        {
          volume = "local-lvm:vm-206-data"
          path   = "/opt/rocketchat-data"
          size   = var.is_prod ? "10" : "5"
          backup = true
        }
        ] : []
       groups       = ["docker_hosts", "portainer_agents"]
    }

    z1_unifi = {
       vm_id = 207
       enabled = var.is_prod
       pve_node = var.is_prod ? "ninja" : "shockwave"
       hostname = "z1-unifi"
       cpu_cores    = 2
       memory_dedicated = 2048
       memory_swap = 512
       datastore_id     = "local-lvm"
       datastore_size   = "10"
       ipv4_address = cidrhost(local.vlans.core.network, var.infra_z1_unifi_host_id)
       ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_z1_unifi_iid}"
       start_on_boot    = "true"
       mount_points = var.is_prod ? [
        {
          volume = "local-lvm:vm-207-data"
          path   = "/opt/unifi-data"
          size   = var.is_prod ? "10" : "5"
          backup = true
        }
        ] : []
       groups       = ["docker_hosts", "portainer_agents"]
    }
    # ----------------------- CORE APPS end -------------------------

  }

  virtual = {
    ipv4_address = cidrhost(local.vlans.core.network, var.infra_vip_host_id)
    ipv6_address = "${local.vlans.core.ula_prefix}${var.infra_vip_iid}"
  }

  # For Ansible inventory.ini
  # Merge all hosts into centralized map
  # Except: vm_instances
  all_hosts = merge(
    local.standalone_instances,
    local.pve_nodes,
    local.lxc_instances,
    local.k8s_nodes
  )


  active_hosts = {
    for k, h in local.all_hosts : h.hostname => merge(h, {
      host_entry = join(" ", compact([
        h.hostname,
        lookup(h, "ipv4_address", null) != null ? "ansible_host=${h.ipv4_address}" : "",
        lookup(h, "ipv6_address", null) != null ? "ansible_host_ipv6=${h.ipv6_address}" : "",
        lookup(h, "user", null) != null ? "ansible_user=${h.user}" : "",
        lookup(h, "extra_vars", null) != null ? h.extra_vars : ""
      ]))
    })
    if lookup(h, "enabled", true)
  }

  all_groups = distinct(flatten([
    for h in local.active_hosts : h.groups
  ]))

  grouped_hosts = {
    for grp in local.all_groups : grp => [
      for h in local.active_hosts : h
      if contains(h.groups, grp)
    ]
  }

}

resource "local_file" "ansible_inventory" {
  filename = "../../../ansible/inventories/${var.is_prod ? "prod" : "staging"}/inventory.ini"
  content  = templatefile("../core/templates/inventory.ini.tftpl", {
    grouped_hosts         = local.grouped_hosts
    active_hosts          = local.active_hosts
    is_prod               = var.is_prod
    cloudflare_account_id = var.cloudflare_account_id
    r2_opnsense           = try(cloudflare_r2_bucket.backups["opnsense"].name, "")
    r2_truenas            = try(cloudflare_r2_bucket.backups["truenas"].name, "")
    r2_unifi              = try(cloudflare_r2_bucket.backups["unifi"].name, "")
    dns_gateway_ipv4      = local.vlans.core.gateway_ipv4
    dns_gateway_ipv6      = local.vlans.core.gateway_ipv6
    virtual_ipv4          = local.virtual.ipv4_address
    virtual_ipv6          = local.virtual.ipv6_address
  })
}

resource "proxmox_virtual_environment_dns" "node_dns" {
  for_each = {
  for k, v in local.pve_nodes : k => v
  if v.enabled && var.is_prod
  }

  node_name = each.value.hostname
  servers   = [local.virtual.ipv4_address, local.virtual.ipv6_address, local.vlans.core.gateway_ipv4]
  domain    = var.shared_searchdomain

}

resource "proxmox_network_linux_bridge" "vmbr1_primus" {
  count  = var.is_prod ? 1 : 0

  node_name = "primus"
  name      = "vmbr1"
  address   = "${cidrhost(local._networks.storage, var.infra_primus_host_id)}/24"
  comment   = "Dedicated Storage Network"
  ports     = ["enp1s0"]
}

module "k8s_nodes" {
  for_each = { for k, v in local.k8s_nodes : k => v if v.enabled }

  source         = "../../modules/proxmox/vm"
  pve_node       = each.value.pve_node
  template_id    = each.value.template_id

  vm_name        = each.value.hostname
  vm_id          = each.value.vm_id
  hostname       = each.value.hostname
  username       = each.value.user
  cpu_cores      = each.value.cpu_cores
  memory         = each.value.memory
  size           = each.value.size
  os             = each.value.os
  storage        = each.value.storage

  public_ssh_key = var.shared_ssh_public_key_file
  nameservers    = var.shared_nameservers
  searchdomain   = var.shared_searchdomain

  vlan_id          = var.is_prod ? local.vlans.lab.id : null
  bridge_frontend  = each.value.bridge_frontend
  ipv4_address     = each.value.ipv4_address != "" ? "${each.value.ipv4_address}/24" : ""
  ipv4_gateway     = local.vlans.lab.gateway_ipv4

  ipv6_address     = each.value.ipv6_address != "" ? "${each.value.ipv6_address}/64" : ""
  ipv6_gateway     = local.vlans.lab.gateway_ipv6


  bridge_storage       = each.value.bridge_storage
  storage_ipv4_address = each.value.storage_ipv4_address != "" ? "${each.value.storage_ipv4_address}/24" : ""

  on_boot  = each.value.on_boot
}


module "lxc_instances" {
  for_each = { for k, v in local.lxc_instances : k => v if v.enabled }

  source   = "../../modules/proxmox/lxc"
  pve_node = each.value.pve_node
  vm_id    = each.value.vm_id
  hostname = each.value.hostname

  nameservers  = [local.virtual.ipv4_address, local.virtual.ipv6_address, local.vlans.core.gateway_ipv4, local.vlans.core.gateway_ipv6]
  searchdomain   = var.shared_searchdomain

  memory_dedicated = each.value.memory_dedicated
  memory_swap      = each.value.memory_swap
  cpu_cores        = each.value.cpu_cores

  vlan_id          = var.is_prod ? local.vlans.core.id : null
  template_file_id = var.shared_lxc_template_file_id

  ipv4_address     = each.value.ipv4_address != "" ? "${each.value.ipv4_address}/24" : ""
  gateway      = local.vlans.core.gateway_ipv4
  ipv6_address     = each.value.ipv6_address != "" ? "${each.value.ipv6_address}/64" : ""
  ipv6_gateway = local.vlans.core.gateway_ipv6

  ssh_public_key_file = var.shared_ssh_public_key_file
  datastore_id        = each.value.datastore_id
  datastore_size      = each.value.datastore_size
  start_on_boot       = each.value.start_on_boot

  mount_points = lookup(each.value, "mount_points", [])
}

resource "proxmox_storage_pbs" "pbs_backup" {
  count = var.is_prod ? 1 : 0

  id          = "sentinel_datastore_1"
  nodes       = ["ninja"]
  server      = local.standalone_instances.sentinel.ipv4_address
  datastore   = "datastore_1"
  username       = var.pbs_username
  password       = var.pbs_password
  fingerprint    = var.pbs_fingerprint
  encryption_key = var.pbs_encryption_key_data
  content = ["backup"]
}

resource "proxmox_backup_job" "daily_pbs_backup" {
  count = var.is_prod ? 1 : 0

  id       = "daily-pbs-backup"
  enabled  = true
  schedule = "23:00"
  storage = proxmox_storage_pbs.pbs_backup[count.index].id

  all = true
  mode = "snapshot"
  notes_template = "{{guestname}} backup"
  prune_backups = {
    "keep-last"    = "7"
    "keep-daily"   = "30"
    "keep-monthly" = "6"
  }
  mailto = var.backup_notification_email
}

