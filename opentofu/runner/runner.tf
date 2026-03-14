variable "runner_name" {
  type        = string
  description = "The name of the virtual machine as it appears in the Proxmox UI."
}

variable "runner_vm_id" {
  type        = number
  description = "The VMID of the runner."
}

variable "runner_ipv4" {
  type        = string
  description = "The static IPv4 address for the runner, including the CIDR prefix (e.g., 192.168.1.50/24)."
}

variable "runner_ipv6" {
  type        = string
  description = "The static IPv6 address for the runner, including the CIDR prefix (e.g. /64)."
}

variable "runner_memory" {
  type        = number
  description = "The amount of dedicated RAM for the virtual machine in Megabytes."
  default     = 4096
}

variable "runner_cpu_cores" {
  type        = number
  description = "The number of CPU cores allocated to the virtual machine."
  default     = 2
}

variable "runner_storage" {
  type        = string
  description = "The storage id for the root disk."
  default = "local-lvm"
}

variable "runner_size" {
  type        = number
  description = "The storage size in GB."
  default = 20
}

variable "runner_username" {
  type        = string
  description = "The username on the runner instance."
  sensitive = true
}

variable "runner_hostname" {
  type        = string
  description = "The hostname on the runner instance."
}

variable "runner_gateway_ipv4" {
  type        = string
  description = "The ipv4 gateway of the runner."
}

variable "runner_gateway_ipv6" {
  type        = string
  description = "The ipv6 gateway of the runner."
}

variable "runner_vlan_id" {
  type        = number
  description = "The vlan id on the runner instance."
  default = 22
}

variable "runner_os" {
  type        = string
  default     = "l26"
  description = "The operating-system of the vm."
}
