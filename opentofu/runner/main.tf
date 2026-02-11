module "vm" {
  source      = "../modules/proxmox/vm"

  vm_name     = var.runner_name
  vm_id     = var.runner_vm_id
  ipv4_address  = var.runner_ip
  cpu_cores = var.runner_cpu_cores
  os = var.runner_os
  memory = var.runner_memory
  storage = var.runner_storage
  size = var.runner_size
  username = var.runner_username
  hostname = var.runner_hostname
  public_ssh_key = var.shared_ssh_public_key_file
  pve_node = var.shared_virtual_environment_node
  gateway     = var.shared_network_gateway
  template_id = var.shared_vm_template_id
}
