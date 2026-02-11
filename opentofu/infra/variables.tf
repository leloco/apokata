variable "tang_hostname" {
  type        = string
  description = "The hostname for the Tang LXC container."
}

variable "tang_ipv4_address" {
  type        = string
  description = "The IPv4 address for Tang in CIDR notation (e.g., 192.168.1.20/24)."
}

variable "tang_root_password" {
  type        = string
  description = "The root password for the Tang container."
  sensitive   = true
}

variable "tang_datastore_id" {
  type        = string
  description = "The Proxmox storage identifier for the Tang disk."
}

variable "tang_datastore_size" {
  type        = number
  description = "The disk size for Tang in GB."
}

variable "tang_vm_id" {
  type        = number
  description = "The dedicated ID for the LXC container (VMID)."
}

variable "tang_start_on_boot" {
  type        = bool
  description = "Should the container start automatically when the Proxmox node boots?"
  default = true
}
