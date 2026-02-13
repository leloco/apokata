terraform {
  backend "s3" {
    bucket   = "apokata"
    key      = "terraform.tfstate"
    endpoint = "https://44cefd0a80a53b37651778cb6e36a870.r2.cloudflarestorage.com"
    region   = "eeur"

    # disable AWS specific flags
    skip_credentials_validation = true
    skip_region_validation      = true
    skip_requesting_account_id  = true
    skip_metadata_api_check     = true
    
    use_path_style              = true 
  }
}
