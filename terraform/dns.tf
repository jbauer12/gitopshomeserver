locals {
  dns_entries = [
    "argocd",
    "sabnzbd",
    "longhorn",
    "radarr",
    "sonarr",
    "prowlarr",
    "jellyfin"
  ]
}

resource "pihole_dns_record" "apps" {
  for_each = toset(local.dns_entries)
  domain = "${each.key}.${var.domain_name}"
  ip     = var.master_nodes[0]
}

resource "cloudflare_dns_record" "dns_entries" {
  for_each = toset(local.dns_entries)
  zone_id = var.zone_id
  name    = "${each.key}"
  type    = "CNAME"
  ttl     = 1
  content   = "${var.domain_name}" 
  proxied = true
}

