# TODO Group variables into more logical sections
variable "argocd_admin_password" {
  type        = string
  sensitive   = true
  description = "Bcrypt-hashed ArgoCD admin password"
}
variable "pihole_password" {
  type        = string
  sensitive   = true
  description = "Pihole password"
}
variable "email" {
  type        = string
}

variable "argocd_admin_password_decrypted" {
  type        = string
  sensitive   = true
  description = "Decrypted ArgoCD admin password"
}
variable "ssh_user"{
  type        = string
  description = "SSH user"
}

variable "master_nodes" {
  type    = list(string)
}

variable "worker_nodes" {
  type    = list(string)
}

variable "secret_key_path" {
  type = string
  description = "Where Sealed Secret Keys lies." 
}
variable "domain_name" {
  type = string
  description = "Domain name for the cluster"
}
variable "cloudflare_api_token" {
  type        = string
  sensitive   = true
  description = "Cloudflare API token"
  }
variable "zone_id" {
  type        = string
  sensitive   = true
  description = "Cloudflare zone ID"
}