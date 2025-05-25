resource "pihole_dns_record" "argocd" {
  domain = "argocd.mydomain.com"
  ip     = "192.168.178.69"
}