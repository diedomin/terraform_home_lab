terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.3"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
