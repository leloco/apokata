variable "shared_pve_endpoint" {
  description = "The API endpoint URL for the Proxmox VE cluster."
  type        = string
}

variable "shared_pve_api_token" {
  description = "Proxmox API token in the format: USER@REALM!TOKENID=UUID."
  type        = string
  sensitive   = true
}

variable "shared_ssh_public_key_file" {
  description = "The path to the public key file for default user access."
  type        = string
}

