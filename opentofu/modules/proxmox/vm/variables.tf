variable "vm_name" {
  type        = string
  description = "The display name of the virtual machine or container."
}

variable "vm_id" {
  type        = number
  description = "The unique ID (VMID) within the Proxmox cluster."
}

variable "ipv4_address" {
  type        = string
  description = "The IPv4 address including CIDR suffix (e.g., 10.0.20.10/24)."
}

variable "ipv4_gateway" {
  type        = string
  description = "The IPv4 address of the default gateway."
}

variable "ipv6_address" {
  type        = string
  description = "The IPv6 address including CIDR suffix."
}

variable "ipv6_gateway" {
  type        = string
  description = "The IPv6 address of the default gateway."
}

variable "cpu_cores" {
  type        = number
  description = "The number of CPU cores assigned to the resource."
}

variable "pve_node" {
  type        = string
  description = "The name of the Proxmox node where the resource will be created."
}

variable "template_id" {
  type        = number
  description = "The ID of the source template used for the cloning process."
}

variable "memory" {
  type        = number
  description = "The amount of RAM in megabytes (MB)."
}

variable "username" {
  type        = string
  description = "The primary administrative username for the system."
}

variable "hostname" {
  type        = string
  description = "The hostname for the operating system."
}

variable "vlan_id" {
  type        = number
  description = "The VLAN tag ID for the network interface."
}

variable "public_ssh_key" {
  type        = string
  description = "The public SSH key used for authentication."
}

variable "os" {
  type        = string
  description = "The operating system type (e.g., ubuntu, debian)."
}

variable "size" {
  type        = number
  description = "The size of the root disk in gigabytes (GB)."
}

variable "storage" {
  type        = string
  description = "The name of the Proxmox storage where the disk will be stored."
}

variable "nameservers" {
  type        = list(string)
  description = "A list of DNS nameservers (e.g., VIPs and local gateways)."
}

variable "searchdomain" {
  type        = string
  description = "The DNS search domain for the system (e.g., x3dh.de)."
}
