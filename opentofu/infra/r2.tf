variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare Account ID"
}

locals {
  backup_buckets = {
    opnsense = "backup-opnsense"
    truenas  = "backup-truenas"
    unifi    = "backup-unifi"
  }
}

resource "cloudflare_r2_bucket" "backups" {
  for_each   = local.backup_buckets
  account_id = var.cloudflare_account_id
  name       = "apokata-${each.value}"

  lifecycle {
    prevent_destroy = true
  }
}

resource "cloudflare_r2_bucket_lifecycle" "backup_retention" {
  for_each    = cloudflare_r2_bucket.backups
  account_id  = var.cloudflare_account_id
  bucket_name = each.value.name

  rules = [
    {
      id      = "expire-daily-backups"
      enabled = true
      conditions = {
        prefix = "daily/"
      }
      delete_objects_transition = {
        condition = {
          type    = "Age"
          max_age = 2592000 # 30 days in seconds
        }
      }
    },
    {
      id      = "expire-monthly-backups"
      enabled = true
      conditions = {
        prefix = "monthly/"
      }
      delete_objects_transition = {
        condition = {
          type    = "Age"
          max_age = 31536000 # 365 days in seconds
        }
      }
    }
  ]
}
