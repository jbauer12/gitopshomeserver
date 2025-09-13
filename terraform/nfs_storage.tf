resource "helm_release" "storage_class_nfs" {
  name       = "nfs-subdir-external-provisioner"
  repository = "https://kubernetes-sigs.github.io/nfs-subdir-external-provisioner/"
  chart      = "nfs-subdir-external-provisioner"
  namespace  = "kube-system"
  create_namespace = false

  set {
    name  = "nfs.server"
    value = "192.168.178.73"
  }

  set {
    name  = "nfs.path"
    value = "/nas-shared"
  }

  set {
    name  = "storageClass.name"
    value = "nfs-client"
  }

  set {
    name  = "storageClass.defaultClass"
    value = "true"
  }
  depends_on = [
    null_resource.install_k3s_master,
    null_resource.join_k3s_worker
  ]
}