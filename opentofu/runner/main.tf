module "vm" {
  source         = "../modules/proxmox/vm"
  vm_name        = var.runner_vm_name
  vm_id          = var.runner_vm_id
  ipv4_address   = var.runner_ipv4_address
  ipv4_gateway   = var.runner_ipv4_gateway
  ipv6_address   = var.runner_ipv6_address
  ipv6_gateway   = var.runner_ipv6_gateway
  cpu_cores      = var.runner_cpu_cores
  os             = var.runner_os
  memory         = var.runner_memory
  storage        = var.runner_storage
  size           = var.runner_size
  username       = var.runner_username
  hostname       = var.runner_hostname
  nameservers    = var.shared_nameservers
  searchdomain   = var.shared_searchdomain
  vlan_id        = var.runner_vlan_id
  public_ssh_key = var.shared_public_ssh_key
  pve_node       = var.runner_pve_node
  template_id    = var.shared_vm_template_id
}


