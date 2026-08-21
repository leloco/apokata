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
  for_each   = cloudflare_r2_bucket.backups
  account_id = var.cloudflare_account_id
  bucket_name = each.value.name

  rules = [
    {
      id      = "expire-daily-backups"
      enabled = true
      conditions = {
        prefix = "daily/"
      }
      expire = {
        days = 30
      }
    },
    {
      id      = "expire-monthly-backups"
      enabled = true
      conditions = {
        prefix = "monthly/"
      }
      expire = {
        days = 365
      }
    }
  ]
}
