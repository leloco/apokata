variable "tang_root_password" {
  type        = string
  description = "The root password for the Tang container."
  sensitive   = true
}

variable "default_datastore_id" {
  type        = string
  description = "The Proxmox storage identifier for the disk."
}

variable "default_datastore_size" {
  type        = number
  description = "The disk size for in GB."
}

variable "default_start_on_boot" {
  type        = bool
  description = "Should the container start automatically when the Proxmox node boots?"
  default = true
}

variable "prowl_root_password" {
  type        = string
  description = "The password for the Pi-Hole web-interface"
  sensitive   = true
}

