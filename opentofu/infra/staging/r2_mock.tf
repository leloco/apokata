variable "cloudflare_account_id" {
  type        = string
  description = "Cloudflare Account ID"
  default     = ""
}

resource "cloudflare_r2_bucket" "backups" {
  for_each   = toset([])
  account_id = ""
  name       = ""
}
