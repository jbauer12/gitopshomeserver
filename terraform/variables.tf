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

variable "longhorn_backup_smb_username" {
  type        = string
  sensitive   = true
  description = "SMB username for Longhorn backup"
}
variable "longhorn_backup_smb_password" {
  type        = string
  sensitive   = true
  description = "SMB password for Longhorn backup"
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