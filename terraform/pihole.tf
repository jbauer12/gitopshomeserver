resource "pihole_dns_record" "argocd" {
  domain = "argocd.mydomain.com"
  ip     = "192.168.178.69"
}

resource "pihole_dns_record" "sabnzbd" {
  domain = "sabnzbd.mydomain.com"
  ip     = "192.168.178.69"
}

resource "pihole_dns_record" "longhorn" {
  domain = "longhorn.mydomain.com"
  ip     = "192.168.178.69"
  }

resource "pihole_dns_record" "radarr" {
  domain = "radarr.mydomain.com"
  ip     = "192.168.178.69"
  }

resource "pihole_dns_record" "sonarr" {
  domain = "sonarr.mydomain.com"
  ip     = "192.168.178.69"
  }
resource "pihole_dns_record" "prowlarr" {
  domain = "prowlarr.mydomain.com"
  ip     = "192.168.178.69"
  }

resource "pihole_dns_record" "longhorn_2" {
  domain = "jonelli.uk"
  ip     = "192.168.178.69"
  }