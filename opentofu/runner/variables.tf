# ==========================================
# RUNNER VARIABLES (prod.runner.env)
# ==========================================

variable "runner_vm_id" {
  description = "The unique Proxmox VM ID for the GitHub runner."
  type        = number
}

variable "runner_vm_name" {
  description = "The name of the runner VM in Proxmox."
  type        = string
}

variable "runner_pve_node" {
  description = "The target Proxmox node to deploy the runner on."
  type        = string
}

variable "runner_hostname" {
  description = "The internal OS hostname for the runner."
  type        = string
}

variable "runner_username" {
  description = "The default OS username for the runner."
  type        = string
}

variable "runner_os" {
  description = "The OS type identifier (e.g., l26 for Linux kernel 2.6+)."
  type        = string
}

variable "runner_cpu_cores" {
  description = "The number of CPU cores allocated to the runner."
  type        = number
}

variable "runner_memory" {
  description = "The amount of RAM allocated to the runner in megabytes."
  type        = number
}

variable "runner_storage" {
  description = "The Proxmox datastore name for the runner's primary disk."
  type        = string
}

variable "runner_size" {
  description = "The size of the runner's primary disk (e.g., 32G)."
  type        = string
}

variable "runner_vlan_id" {
  description = "The VLAN tag for the runner's network interface."
  type        = number
}

variable "runner_ipv4_address" {
  description = "The static IPv4 address and CIDR for the runner (e.g., 10.0.0.10/24)."
  type        = string
}

variable "runner_ipv4_gateway" {
  description = "The IPv4 gateway address for the runner."
  type        = string
}

variable "runner_ipv6_address" {
  description = "The static IPv6 address and CIDR for the runner."
  type        = string
}

variable "runner_ipv6_gateway" {
  description = "The IPv6 gateway address for the runner."
  type        = string
}
