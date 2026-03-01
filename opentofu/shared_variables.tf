variable "shared_virtual_environment_endpoint" {
  type        = string
  description = "The URL for the Proxmox Virtual Environment"
}

variable "shared_virtual_environment_node" {
  type        = string
  description = "The node in Proxmox Virtual Environment"
  default = "ninja"
}

variable "shared_virtual_environment_api_token" {
  type        = string
  description = "API Token in the following format: USER@REALM!TOKENID=UUID"
  sensitive   = true
}

variable "shared_network_bridge" {
  description = "Connect Proxmox Bridge to containers"
  type        = string
  default     = "vmbr0"
}

variable "shared_ssh_public_key_file" {
  description = "Public key file."
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "shared_lxc_template_file_id" {
  description = "The default template file id"
  type        = string
  default     = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
}

variable "shared_vm_template_id" {
  description = "The id for vm templates"
  type        = number
  default     = 9000
}
