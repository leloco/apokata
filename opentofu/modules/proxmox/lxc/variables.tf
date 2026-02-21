variable "pve_node" {
  type        = string
  description = "The name of the Proxmox node where the container will be created."
}

variable "template_file_id" {
  type        = string
  description = "The ID of the OS template file (e.g., local:vztmpl/ubuntu-22.04.tar.zst)."
}

variable "template_type" {
  type        = string
  description = "The OS type of the template (e.g., ubuntu, debian)."
  default     = "debian"
}

variable "hostname" {
  type        = string
  description = "The hostname for the LXC container."
}

variable "ipv4_address" {
  type        = string
  description = "IPv4 address in CIDR format."
}

variable "ipv6_address" {
  type        = string
  description = "IPv6 address in CIDR format."
}

variable "gateway" {
  type        = string
  description = "The IPv4 gateway address."
}

variable "ipv6_gateway" {
  type        = string
  description = "The IPv6 gateway address."
}

variable "ssh_public_key_file" {
  type        = string
  description = "Path to the SSH public key file."
}

variable "root_password" {
  type        = string
  description = "The root password for the container."
  sensitive   = true
}

variable "network_bridge" {
  type        = string
  description = "The network bridge to attach the interface to."
  default     = "vmbr0"
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores."
  default     = 1
}

variable "memory_dedicated" {
  type        = number
  description = "Dedicated memory in MB."
  default     = 512
}

variable "memory_swap" {
  type        = number
  description = "Swap memory in MB."
  default     = 512
}

variable "datastore_id" {
  type        = string
  description = "The identifier for the datastore where the disk will be stored."
  default = "local-lvm"
}

variable "datastore_size" {
  type        = number
  description = "The size of the disk in GB."
}

variable "start_on_boot" {
  type        = bool
  description = "Whether the container should start on node boot."
  default     = true
}

variable "vm_id" {
  type        = number
  description = "The dedicated ID for the LXC container (VMID)."
  default     = null 
}

variable "nesting" {
  type        = bool
  description = "Activates nesting (for Docker oder systemd compability)"
  default     = true  
}
