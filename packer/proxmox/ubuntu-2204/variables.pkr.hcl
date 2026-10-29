variable "target_node" {
  type    = string
  default = "ninja"
}

variable "template_id" {
  type    = number
  default = "9000"
}

variable "template_name" {
  type    = string
  default = "ubuntu-2204-golden-image"
}

variable "ssh_username" {
  type    = string
  default = "ubuntu"
}

variable "ssh_private_key_file" {
  type    = string
  default = "~/.ssh/id_rsa"
}

