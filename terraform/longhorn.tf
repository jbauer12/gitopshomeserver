
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


resource "kubernetes_secret" "longhorn_backup_secret" {
  metadata {
    name      = "longhorn-backup-secret"
    namespace = "longhorn-system"
  }

  type = "Opaque"

  data = {
    CIFS_USERNAME = var.longhorn_backup_smb_username
    CIFS_PASSWORD = var.longhorn_backup_smb_password
  }
}

resource "helm_release" "longhorn" {
  depends_on = [null_resource.longhorn_prerequisites, kubernetes_secret.longhorn_backup_secret]
  name       = "longhorn"
  namespace  = "longhorn-system"
  repository = "https://charts.longhorn.io/"
  chart      = "longhorn"
  version    = "1.8.1"

  create_namespace = true
  values = [
    yamlencode({
      defaultBackupStore = {
        backupTarget                 = "cifs://192.168.178.1/BILLIGNAS?uid=1000&gid=1000"
        backupTargetCredentialSecret = "longhorn-backup-secret"
        pollInterval                 = 500
      }
      preUpgradeChecker = {
        jobEnabled = false
      }
    })
  ]
}

resource "kubernetes_storage_class" "longhorn_rwx" {
  metadata {
    name = "longhorn-rwx"
  }

  storage_provisioner = "driver.longhorn.io"

  parameters = {
    numberOfReplicas = "3"
    migratable       = "false"   # disable migration for RWX
    fsType           = "ext4"
    nfsOptions       = "vers=4.1,soft,timeo=600,retrans=5"
  }

  allow_volume_expansion = true

  volume_binding_mode = "Immediate"
}
