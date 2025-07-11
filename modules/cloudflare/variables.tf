variable "cloudflare_api_token" {}
variable "zone_id" {}
variable "base_domain" {}
variable "default_ttl" { default = 3600 }

variable "dns_records" {
  type = list(object({
    name     = string
    content  = string
    type     = string
    ttl      = number
    priority = optional(number)
    proxied  = optional(bool)
    tags     = optional(list(string))
  }))
}

variable "instance_records" {
  type = list(object({
    name     = string
    content  = string
    type     = string
    ttl      = number
    priority = optional(number)
    proxied  = optional(bool)
    tags     = optional(list(string))
  }))
}
