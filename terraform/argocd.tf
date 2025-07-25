resource "kubernetes_namespace" "argocd" {
  depends_on = [null_resource.install_k3s_master, null_resource.join_k3s_worker]
  metadata {
    name = "argocd"
  }
}

resource "helm_release" "argocd" {
  depends_on = [helm_release.cert_manager, kubernetes_namespace.argocd]
  name       = "argocd"
  namespace  = kubernetes_namespace.argocd.metadata[0].name
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"
  version    = "5.51.6"

  values = [
    yamlencode({
      configs = {
        params = {
          "server.insecure" = true
        }
        secret = {
          argocdServerAdminPassword       = var.argocd_admin_password
          argocdServerAdminPasswordMtime = timestamp()
        }
      }
    })
  ]
}



resource "argocd_application" "apps" {
  depends_on = [null_resource.install_k3s_master, null_resource.join_k3s_worker, helm_release.argocd]
  metadata {
    name      = "apps"
    namespace = "argocd"
  }

  spec {
    project = "default"

    source {
      repo_url        = "https://github.com/jbauer12/gitopshomeserver"
      path            = "apps"
      target_revision = "HEAD"
    }

    destination {
      server    = "https://kubernetes.default.svc"
      namespace = "argocd"
    }

    sync_policy {
      automated {
        prune       = true
        self_heal   = true
        allow_empty = true
      }
      sync_options = ["Validate=false"]
      retry {
        limit = 5
        backoff {
          duration     = "30s"
          max_duration = "2m"
          factor       = "2"
        }
      }
    }
  }
}
