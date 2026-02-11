locals {
  proxmox_host_ip = split(":", split("/", var.shared_virtual_environment_endpoint)[2])[0]
}

module "tang" {
  source = "../modules/proxmox/lxc"

  pve_node         = var.shared_virtual_environment_node
  vm_id            = var.tang_vm_id
  hostname         = var.tang_hostname
  template_file_id = var.shared_lxc_template_file_id
  
  ipv4_address     = var.tang_ipv4_address
  gateway          = var.shared_network_gateway
  
  ssh_public_key_file = var.shared_ssh_public_key_file
  root_password       = var.tang_root_password
  
  datastore_id     = var.tang_datastore_id
  datastore_size   = var.tang_datastore_size
  start_on_boot    = var.tang_start_on_boot
}
