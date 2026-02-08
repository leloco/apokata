variable "ninja_tang_ipv4" {
  description = "The IPv4 with CIDR"
  type        = string
  sensitive = true 
}

variable "tang_root_password" {
  description = "The root password for the lxc tang"
  type        = string
  sensitive = true 
}

variable "ninja_ops_ipv4" {
  description = "The IPv4 with CIDR"
  type        = string
  sensitive = true 
}

variable "ops_root_password" {
  description = "The root password for the lxc ops"
  type        = string
  sensitive = true 
}


