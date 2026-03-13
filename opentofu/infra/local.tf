
variable "local_tang_root_password" {
  type        = string
  description = "The root password for the Tang container."
  sensitive   = true
}

variable "local_prowl_root_password" {
  type        = string
  description = "The password for the Pi-Hole web-interface"
  sensitive   = true
}

variable "local_vlan_id" {
  type        = number
  description = "The vlan id for the host."
  default = 20
}


