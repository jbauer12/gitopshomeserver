resource "cloudflare_tunnel" "n8n" {
  account_id = var.cloudflare_account_id
  name       = "n8n-tunnel"
  secret     = random_password.tunnel_secret.result
}