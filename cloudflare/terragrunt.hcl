include {
  path = find_in_parent_folders("root.hcl")
}

terraform {
  source = "../modules/cloudflare"
}

#Remote state S3
remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    profile = "default"
    bucket  = local.s3_tfstate_bucket_name
    region  = local.aws_region
    encrypt = true
    skip_bucket_versioning = false
    dynamodb_table = local.dynamodb_tfstate_table_name
    key = "terraform/cloudflare/terraform.tfstate"
  }
}

locals {
  common_vars = read_terragrunt_config(find_in_parent_folders("root.hcl"))

  aws_region                  = local.common_vars.locals.aws_region
  s3_tfstate_bucket_name      = local.common_vars.locals.s3_tfstate_bucket_name
  env                         = local.common_vars.locals.env
  dynamodb_tfstate_table_name = local.common_vars.locals.dynamodb_tfstate_table_name
  base_domain                 = yamldecode(sops_decrypt_file("${get_parent_terragrunt_dir()}/secrets/cloudflare.yml"))["base_domain"]
  default_ttl                 = 3600
}

inputs = {
  zone_id              = yamldecode(sops_decrypt_file("${get_parent_terragrunt_dir()}/secrets/cloudflare.yml"))["zone_id"]
  cloudflare_api_token = yamldecode(sops_decrypt_file("${get_parent_terragrunt_dir()}/secrets/cloudflare.yml"))["cloudflare_api_token"]
  base_domain          = local.base_domain
  default_ttl          = local.default_ttl

  dns_records = [
    { name = "${local.base_domain}", content = "mx01.dondominio.com", type = "MX", ttl = 300, priority = 10 },
    { name = "${local.base_domain}", content = "v=spf1 include:spf.dondominio.com", type = "TXT", ttl = 300 },
    { name = "_dmarc", content = "v=DMARC1; p=none; rua=mailto:reportes@${local.base_domain}; ruf=mailto:reportes@${local.base_domain}; pct=100", type = "TXT", ttl = 300 },
    { name = "atlas", content = "192.168.100.50", type = "A", ttl = local.default_ttl, proxied = false },
    { name = "hermes", content = "192.168.100.48", type = "A", ttl = local.default_ttl, proxied = false},
    { name = "stf", content = "192.168.100.47", type = "A", ttl = local.default_ttl, proxied = false},
    { name = "jellyfin", content = "${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "docmost", content = "${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "immich", content = "${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "nextcloud", content = "${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "alertmanager", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "drawio", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "excalidraw", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "grafana", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "home", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "kuma", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "paperless", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "pdf", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "private-proxy", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "prometheus", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "qbittorrent", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
    { name = "tools", content = "hermes.${local.base_domain}", type = "CNAME", ttl = local.default_ttl, proxied = false },
  ]
}

