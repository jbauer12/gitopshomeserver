variable "argocd_admin_password" {
  type        = string
  sensitive   = true
  description = "Bcrypt-hashed ArgoCD admin password"
}

variable "argocd_admin_password_decrypted" {
  type        = string
  sensitive   = true
  description = "Decrypted ArgoCD admin password"
}