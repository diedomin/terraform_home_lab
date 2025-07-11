resource "cloudflare_dns_record" "dns_records" {
  for_each = { for rec in var.dns_records : "${rec.name}_${rec.type}" => rec }

  zone_id = var.zone_id
  name    = (each.value.name == var.base_domain ? each.value.name : "${each.value.name}.${var.base_domain}")

  type     = each.value.type
  content  = each.value.content
  ttl      = each.value.ttl
  priority = lookup(each.value, "priority", null)
  proxied  = lookup(each.value, "proxied", false)
  tags     = lookup(each.value, "tags", [])

  lifecycle {
    ignore_changes = [tags]
  }
}

resource "cloudflare_dns_record" "instance_records" {
  for_each = { for rec in var.instance_records : "${rec.name}_${rec.type}" => rec }

  zone_id = var.zone_id
  name    = (each.value.name == var.base_domain ? each.value.name : "${each.value.name}.${var.base_domain}")

  type     = each.value.type
  content  = each.value.content
  ttl      = each.value.ttl
  priority = lookup(each.value, "priority", null)
  proxied  = lookup(each.value, "proxied", false)
  tags     = lookup(each.value, "tags", [])

  lifecycle {
    ignore_changes = [tags]
  }
}
