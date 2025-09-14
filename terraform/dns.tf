locals {
  dns_entries = [
    "argocd",
    "sabnzbd",
    "radarr",
    "sonarr",
    "prowlarr",
    "jellyfin",
    "opencloud",
    "cloud"
      ]
}

resource "pihole_dns_record" "apps" {
  for_each = toset(local.dns_entries)
  domain = "${each.key}.${var.domain_name}"
  ip     = var.master_nodes[0]
}

resource "pihole_dns_record" "omv" {
  domain = "omv.${var.domain_name}"
  ip     = "192.168.178.73"
}

resource "cloudflare_dns_record" "dns_entries" {
  for_each = toset(local.dns_entries)
  zone_id = var.zone_id
  name    = "${each.key}"
  type    = "CNAME"
  ttl     = 3600
  content   = "${var.domain_name}" 
  proxied = false
}

