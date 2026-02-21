# tang
variable "tang_hostname" {
  type        = string
  description = "The hostname for the Tang LXC container."
}

variable "tang_ipv4_address" {
  type        = string
  description = "The IPv4 address for Tang in CIDR notation (e.g., 192.168.1.20/24)."
}

variable "tang_ipv6_address" {
  type        = string
  description = "The IPv6 address for tang in CIDR notation (e.g., fd69:efa6:36fd::20/64)."
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

# prowl
variable "prowl_hostname" {
  type        = string
  description = "The hostname for the prowl LXC container."
}

variable "prowl_ipv4_address" {
  type        = string
  description = "The IPv4 address for prowl in CIDR notation (e.g., 192.168.1.20/24)."
}

variable "prowl_ipv6_address" {
  type        = string
  description = "The IPv6 address for prowl in CIDR notation (e.g., fd69:efa6:36fd::20/64)."
}

variable "prowl_root_password" {
  type        = string
  description = "The password for the Pi-Hole web-interface"
  sensitive   = true
}

variable "prowl_datastore_id" {
  type        = string
  description = "The Proxmox storage identifier for the prowl disk."
}

variable "prowl_datastore_size" {
  type        = number
  description = "The disk size for prowl in GB."
}

variable "prowl_vm_id" {
  type        = number
  description = "The dedicated ID for the LXC container (VMID)."
}

variable "prowl_start_on_boot" {
  type        = bool
  description = "Should the container start automatically when the Proxmox node boots?"
  default = true
}
