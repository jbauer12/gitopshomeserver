terraform {
  required_providers {
    argocd = {
      source = "argoproj-labs/argocd"
      version = "7.6.0"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
}
provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}
provider "argocd" {
  port_forward = true
  username  = "admin"
  password= var.argocd_admin_password_decrypted
  plain_text = true
}
