resource "pihole_dns_record" "argocd" {
  domain = "argocd.jonelli.uk"
  ip     = "192.168.178.69"
}

resource "pihole_dns_record" "sabnzbd" {
  domain = "sabnzbd.jonelli.uk"
  ip     = "192.168.178.69"
}

resource "pihole_dns_record" "longhorn" {
  domain = "longhorn.jonelli.uk"
  ip     = "192.168.178.69"
  }

resource "pihole_dns_record" "radarr" {
  domain = "radarr.jonelli.uk"
  ip     = "192.168.178.69"
  }

resource "pihole_dns_record" "sonarr" {
  domain = "sonarr.jonelli.uk"
  ip     = "192.168.178.69"
  }
resource "pihole_dns_record" "prowlarr" {
  domain = "prowlarr.jonelli.uk"
  ip     = "192.168.178.69"
  }