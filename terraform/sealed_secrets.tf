resource "kubernetes_secret" "sealed-secrets-key" {
  depends_on = [null_resource.install_k3s_master, null_resource.join_k3s_worker]
  metadata {
    name      = "sealed-secrets-key"
    namespace = "kube-system"
  }
  data = {
    # "tls.crt" = file("${var.secret_key_path}/tls.crt")
    # "tls.key" = file("${var.secret_key_path}/tls.key")
    "tls.crt" = file("${var.secret_key_path}/tls.crt.decoded")
    "tls.key" = file("${var.secret_key_path}/tls.key.decoded")

  }
  type = "kubernetes.io/tls"
}

resource "helm_release" "sealed-secrets" {
  depends_on = [kubernetes_secret.sealed-secrets-key]
  name       = "sealed-secrets"
  namespace  = "kube-system"
  repository = "https://bitnami-labs.github.io/sealed-secrets"
  chart      = "sealed-secrets"
  version    = "2.15.3"

  values = [
    yamlencode({
      fullnameOverride = "sealed-secrets"
      controller = {
        create = true
        resources = {
          limits = {
            cpu    = "100m"
            memory = "128Mi"
          }
          requests = {
            cpu    = "50m"
            memory = "64Mi"
          }
        }
      }
    })
  ]
}