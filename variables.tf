variable "virtual_environment_endpoint" {
  type        = string
  description = "The URL for the Proxmox Virtual Environment"
}

variable "virtual_environment_api_token" {
  type        = string
  description = "API Token in the following format: USER@REALM!TOKENID=UUID"
  sensitive   = true
}

variable "network_gateway" {
  type        = string
  description = "Gateway for all containers"
  sensitive = true
}

variable "network_bridge" {
  description = "Connect Proxmox Bridge to containers"
  type        = string
  default     = "vmbr0"
}

variable "network_subnet" {
  description = "The general subnet"
  type        = string
  sensitive = true 
}

variable "ssh_public_key_file" {
  description = "Path to public key file on host system"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "debian_template_file_id" {
  description = "The default debian template file id"
  type        = string
  default     = "local:vztmpl/debian-12-standard_12.7-1_amd64.tar.zst"
}

variable "datastore_zfs" {
  description = "The default ZFS datastore"
  type        = string
  default     = "wd-red-plus-1"
}

# passwords and ips #

variable "ninja_tang_ipv4" {
  description = "The IPv4 with CIDR"
  type        = string
  sensitive = true 
}
variable "tang_root_password" {
  description = "The root password for the container tang"
  type        = string
  sensitive = true 
}

