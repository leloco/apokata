output "vm_id" {
  value = tostring(proxmox_virtual_environment_container.lxc.vm_id)
}
output "hostname" {
  value = proxmox_virtual_environment_container.lxc.initialization[0].hostname
}

output "ipv4_address" {
  value = split("/", proxmox_virtual_environment_container.lxc.initialization[0].ip_config[0].ipv4[0].address)[0]
}
