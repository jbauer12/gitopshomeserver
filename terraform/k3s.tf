#TODO Build a step after prerequisites to reboot all nodes to apply the changes made by the prerequisites step.

resource "ssh_resource" "prerequisites_k3s_new" {
  for_each     = toset(local.all_nodes)
  host         = each.value
  user         = var.ssh_user
  agent        = false
  private_key  = file("/home/jonas/.ssh/id_rsa")

  file {
    content     = "console=serial0,115200 multipath=off dwc_otg.lpm_enable=0 console=tty1 root=LABEL=writable rootfstype=ext4 rootwait fixrtc cfg80211.ieee80211_regdom=GB cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
    destination = "/tmp/cmdline.txt"
    permissions = "0644"
  }

  commands = [
    "sudo mv /tmp/cmdline.txt /boot/firmware/cmdline.txt",
    "sudo chmod 0700 /boot/firmware/cmdline.txt",
    "sudo apt install -y nfs-common"
  ]
}

resource "null_resource" "install_k3s_master" {
  depends_on = [ssh_resource.prerequisites_k3s_new]
  for_each   = toset(var.master_nodes)

  provisioner "local-exec" {
    command = <<EOT
echo "[*] Installing K3s on master node: ${each.key}"
k3sup install \
  --ip "${each.key}" \
  --user "${var.ssh_user}" \
  --k3s-extra-args "--disable=traefik" \
  --local-path "$HOME/.kube/config" --merge
EOT
    interpreter = ["/bin/bash", "-c"]
  }
}

resource "null_resource" "join_k3s_worker" {
  depends_on = [ssh_resource.prerequisites_k3s_new]
  for_each   = toset(var.worker_nodes)

  provisioner "local-exec" {
    command = <<EOT
echo "[*] Joining worker node: ${each.key} to master ${var.master_nodes[0]}"
k3sup join \
  --ip "${each.key}" \
  --user "${var.ssh_user}" \
  --server-ip "${var.master_nodes[0]}"
EOT
    interpreter = ["/bin/bash", "-c"]
  }
}
