# ----------------------- PASSWORDS start -----------------------------
variable "infra_tang_root_password" {
  type        = string
  description = "The root password for the Tang container."
  sensitive   = true
}

variable "infra_prowl_root_password" {
  type        = string
  description = "The password for the Pi-Hole web-interface"
  sensitive   = true
}
# ----------------------- PASSWORDS end -----------------------------

# ----------------------- VLANS start -----------------------------
variable "infra_trusted_cidr" {
  type        = string
  description = "The CIDR id for the trusted VLAN."
  sensitive = true
}

variable "infra_trusted_vlan_id" {
  type        = number
  description = "The VLAN id for trusted"
  sensitive = true
}

variable "infra_trusted_prefix" {
  type        = string
  description = "The prefix for the ipv6 network for VLAN trusted."
  sensitive = true
}

variable "infra_trusted_gateway_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the gateway of VLAN trusted."
  sensitive = true
}

variable "infra_trusted_gateway_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the gateway of VLAN trusted."
  sensitive = true
}
# ----
variable "infra_core_cidr" {
  type        = string
  description = "The CIDR id for the core VLAN."
  sensitive = true
}

variable "infra_core_vlan_id" {
  type        = number
  description = "The VLAN id for core."
  sensitive = true
}

variable "infra_core_prefix" {
  type        = string
  description = "The prefix for the ipv6 network for VLAN core."
  sensitive = true
}

variable "infra_core_gateway_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the gateway of VLAN core."
  sensitive = true
}

variable "infra_core_gateway_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the gateway of VLAN core."
  sensitive = true
}
# ----
variable "infra_iot_cidr" {
  type        = string
  description = "The CIDR id for the IoT VLAN."
  sensitive = true
}

variable "infra_iot_vlan_id" {
  type        = number
  description = "The VLAN id for IoT."
  sensitive = true
}

variable "infra_iot_prefix" {
  type        = string
  description = "The prefix for the ipv6 network for VLAN IoT."
  sensitive = true
}

variable "infra_iot_gateway_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the gateway of VLAN IoT."
  sensitive = true
}

variable "infra_iot_gateway_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the gateway of VLAN IoT."
  sensitive = true
}
# ----
variable "infra_lab_cidr" {
  type        = string
  description = "The CIDR id for the Lab VLAN."
  sensitive = true
}

variable "infra_lab_vlan_id" {
  type        = number
  description = "The VLAN id for Lab."
  sensitive = true
}

variable "infra_lab_prefix" {
  type        = string
  description = "The prefix for the ipv6 network for VLAN Lab."
  sensitive = true
}

variable "infra_lab_gateway_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the gateway of VLAN Lab."
  sensitive = true
}

variable "infra_lab_gateway_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the gateway of VLAN Lab."
  sensitive = true
}
# ----
variable "infra_guest_cidr" {
  type        = string
  description = "The CIDR id for the Guest VLAN."
  sensitive = true
}

variable "infra_guest_vlan_id" {
  type        = number
  description = "The VLAN id for Guest."
  sensitive = true
}

variable "infra_guest_prefix" {
  type        = string
  description = "The prefix for the ipv6 network for VLAN Guest."
  sensitive = true
}

variable "infra_guest_gateway_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the gateway of VLAN Guest."
  sensitive = true
}

variable "infra_guest_gateway_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the gateway of VLAN Guest."
  sensitive = true
}
# ----
variable "infra_work_cidr" {
  type        = string
  description = "The CIDR id for the Work VLAN."
  sensitive = true
}

variable "infra_work_vlan_id" {
  type        = number
  description = "The VLAN id for Guest."
  sensitive = true
}

variable "infra_work_prefix" {
  type        = string
  description = "The prefix for the ipv6 network for VLAN Work."
  sensitive = true
}

variable "infra_work_gateway_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the gateway of VLAN Work."
  sensitive = true
}

variable "infra_work_gateway_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the gateway of VLAN Work."
  sensitive = true
}
# ----------------------- VLANS end -----------------------------
# ----------------------- HOSTS start -----------------------------
variable "infra_runner_alpha_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the host."
  sensitive = true
}
variable "infra_runner_alpha_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the host."
  sensitive = true
}

variable "infra_runner_alpha_user" {
  type        = string
  description = "The username of the host."
  sensitive = true
}
# ----
variable "infra_tang_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the host."
  sensitive = true
}
variable "infra_tang_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the host."
  sensitive = true
}
# ----
variable "infra_prowl_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the host."
  sensitive = true
}
variable "infra_prowl_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the host."
  sensitive = true
}
# ----
variable "infra_shadow_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the host."
  sensitive = true
}
variable "infra_shadow_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the host."
  sensitive = true
}
variable "infra_shadow_user" {
  type        = string
  description = "The username of the host."
  sensitive = true
}
# ----
variable "infra_ninja_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the host."
  sensitive = true
}
variable "infra_ninja_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the host."
  sensitive = true
}
# ----
variable "infra_ironhide_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the host."
  sensitive = true
}
variable "infra_ironhide_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the host."
  sensitive = true
}
# ----
variable "infra_vip_host_id" {
  type        = number
  description = "The host id (ipv4) that identifies the host."
  sensitive = true
}
variable "infra_vip_iid" {
  type        = number
  description = "The interface identifier (ipv6) that identifies the host."
  sensitive = true
}
# ----------------------- HOSTS end -----------------------------

