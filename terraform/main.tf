resource "helm_release" "argocd" {
  name       = "argocd"
  namespace  = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

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
