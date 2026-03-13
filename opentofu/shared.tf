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

variable "shared_datastore_id" {
  type        = string
  description = "The Proxmox storage identifier for the disk."
  default = "local-lvm"
}

variable "shared_datastore_size" {
  type        = number
  description = "The disk size for in GB."
  default = 4
}

variable "shared_start_on_boot" {
  type        = bool
  description = "Should the container start automatically when the Proxmox node boots?"
  default = true
}

variable "shared_pve_endpoint" {
  type        = string
  description = "The URL for the Proxmox Virtual Environment"
}

variable "shared_pve_node" {
  type        = string
  description = "The node in Proxmox Virtual Environment"
  default = "ninja"
}

variable "shared_nameservers" {
  type        = list(string)
  description = "The nameservers for the instance."
  default = null
}

variable "shared_searchdomain" {
  type        = string
  description = "The searchdomain for the instance."
  default = "x3dh.de"
}

variable "shared_pve_api_token" {
  type        = string
  description = "API Token in the following format: USER@REALM!TOKENID=UUID"
  sensitive   = true
}
