
resource "null_resource" "longhorn_prerequisites" {
  depends_on = [null_resource.install_k3s_master, null_resource.join_k3s_worker]

  provisioner "local-exec" {
    command = <<EOT
curl -sSfL -o longhornctl https://github.com/longhorn/cli/releases/download/v1.8.1/longhornctl-linux-amd64
chmod +x longhornctl
./longhornctl --kube-config ~/.kube/config install preflight
./longhornctl --kube-config ~/.kube/config check preflight
EOT
  }
}

resource "helm_release" "longhorn" {
  depends_on = [null_resource.longhorn_prerequisites]
  name       = "longhorn"
  namespace  = "longhorn-system"
  repository = "https://charts.longhorn.io/"
  chart      = "longhorn"
  version    = "1.8.1"

  create_namespace = true

  values = [
    yamlencode({
      preUpgradeChecker = {
        jobEnabled = false
      }
    })
  ]
}
