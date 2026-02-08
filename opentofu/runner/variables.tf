variable "runner_name" {
  type        = string
  description = "The name of the virtual machine as it appears in the Proxmox UI."
}

variable "runner_ip" {
  type        = string
  description = "The static IPv4 address for the runner, including the CIDR prefix (e.g., 192.168.1.50/24)."
}

variable "runner_memory" {
  type        = number
  default     = 4096
  description = "The amount of dedicated RAM for the virtual machine in Megabytes."
}

variable "runner_cpu_cores" {
  type        = number
  default     = 2
  description = "The number of CPU cores allocated to the virtual machine."
}

variable "runner_username" {
  type        = string 
  description = "The username on the runner instance."
}

variable "runner_hostname" {
  type        = string 
  description = "The hostname on the runner instance."
}
variable "runner_os" {
  type        = string 
  default     = "l26"
  description = "The operating-system of the vm."
}
