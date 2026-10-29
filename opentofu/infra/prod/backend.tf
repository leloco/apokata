variable "tofu_state_passphrase" {
  type        = string
  description = "Passphrase to encrypt and decrypt the OpenTofu state file"
  sensitive   = true
}

terraform {
  encryption {
    key_provider "pbkdf2" "passphrase_provider" {
      passphrase = var.tofu_state_passphrase
    }

    method "aes_gcm" "state_encryption" {
      keys = key_provider.pbkdf2.passphrase_provider
    }

    state {
      method = method.aes_gcm.state_encryption
      enforced = false
    }

    plan {
      method = method.aes_gcm.state_encryption
      enforced = true
    }
  }
  backend "s3" {
    bucket   = "apokata-tfstate"
    key      = "terraform.tfstate"
    endpoint = "https://44cefd0a80a53b37651778cb6e36a870.r2.cloudflarestorage.com"
    region   = "eeur"

    # disable AWS specific flags
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    use_path_style              = true
    use_lockfile = false
  }
}
