terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.17.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"    
    }
    pihole = {
      source = "ryanwholey/pihole"
    }
    ssh = {
      source = "loafoe/ssh"
      version = "2.7.0"
    }
    argocd = {
      source  = "argoproj-labs/argocd"
      version = "7.6.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.1"
    }
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "5.5.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
  }


provider "kubernetes" {
  config_path = "~/.kube/config"
}

provider "helm" {
  kubernetes {
    config_path = "~/.kube/config"
  }
}

provider "ssh" {
}

provider "argocd" {
  port_forward = true
  username     = "admin"
  password     = var.argocd_admin_password_decrypted
  plain_text   = true
}


provider "pihole" {
  url      = "http://192.168.178.49/" # PIHOLE_URL
  password = var.pihole_password         # PIHOLE_PASSWORD
}
