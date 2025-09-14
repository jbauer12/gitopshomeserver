resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  namespace  = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.17.2"

  values = [
    yamlencode({
      installCRDs = true
    })
  ]
  depends_on = [null_resource.install_k3s_master, null_resource.join_k3s_worker, kubernetes_namespace.cert-manager]
}
resource "kubernetes_namespace" "cert-manager" {
  depends_on = [null_resource.install_k3s_master, null_resource.join_k3s_worker]
  metadata {
    name = "cert-manager"
  }
}
resource "kubernetes_secret" "cloudflare_api_token" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = "cert-manager"
  }
  type = "Opaque"

  data = {
    "api-token" = var.cloudflare_api_token
  }
}
resource "kubernetes_manifest" "global_cluster_issuer" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name        = "global-cluster-issuer"
    }
    spec = {
      acme = {
        email  = var.email
        server = "https://acme-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "cluster-issuer-account-key"
        }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                email = var.email
                apiTokenSecretRef = {
                  name = "cloudflare-api-token"
                  key  = "api-token"
                }
              }
            }
          }
        ]
      }
    }
  }
}
resource "kubernetes_manifest" "global_cluster_issuer_dev" {
  manifest = {
    apiVersion = "cert-manager.io/v1"
    kind       = "ClusterIssuer"
    metadata = {
      name = "global-cluster-issuer-dev"
    }
    spec = {
      acme = {
        email  = var.email
        # Let's Encrypt staging server for testing
        server = "https://acme-staging-v02.api.letsencrypt.org/directory"
        privateKeySecretRef = {
          name = "cluster-issuer-account-key-dev"
        }
        solvers = [
          {
            dns01 = {
              cloudflare = {
                email = var.email
                apiTokenSecretRef = {
                  name = "cloudflare-api-token"
                  key  = "api-token"
                }
              }
            }
          }
        ]
      }
    }
  }
}


