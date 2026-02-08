terraform {
  required_version = ">= 1.6"
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = ">=0.90.0" 
    }
  }
}

provider "proxmox" {
  endpoint = var.shared_virtual_environment_endpoint
  api_token = var.shared_virtual_environment_api_token

  insecure = true 
  
  ssh {
    username = "root"
    agent = true
  }
}
