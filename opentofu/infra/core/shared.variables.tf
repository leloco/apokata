variable "shared_pve_endpoint" {
  description = "The API endpoint URL for the Proxmox VE cluster."
  type        = string
}

variable "shared_pve_api_token" {
  description = "Proxmox API token in the format: USER@REALM!TOKENID=UUID."
  type        = string
  sensitive   = true
}

variable "shared_nameservers" {
  description = "Space-separated list of DNS nameservers."
  type        = list(string)
  default     = ["10.0.20.10", "fd00:10:0:20::10"]
}

variable "shared_searchdomain" {
  type        = string
  description = "The searchdomain for the instance."
  default = "pve.internal"
}

variable "shared_network_bridge" {
  description = "The default Proxmox network bridge to attach instances to (e.g., vmbr0)."
  type        = string
}

variable "shared_lxc_template_file_id" {
  description = "The Proxmox storage path to the LXC template file."
  type        = string
}

variable "shared_ssh_public_key_file" {
  description = "The path to the public key file for default user access."
  type        = string
}
