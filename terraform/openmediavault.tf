# resource "ssh_resource" "omv_nas" {
#   host         = var
#   user         = var.ssh_user
#   agent        = false
#   private_key  = file("/home/jonas/.ssh/id_rsa")

#   file {
#     content     = "console=serial0,115200 multipath=off dwc_otg.lpm_enable=0 console=tty1 root=LABEL=writable rootfstype=ext4 rootwait fixrtc cfg80211.ieee80211_regdom=GB cgroup_enable=cpuset cgroup_memory=1 cgroup_enable=memory"
#     destination = "/tmp/cmdline.txt"
#     permissions = "0644"
#   }

#   commands = [
#     "apt-get install --yes gnupg",
#     "wget --quiet --output-document=- https://packages.openmediavault.org/public/archive.key | gpg --dearmor --yes --output "/usr/share/keyrings/openmediavault-archive-keyring.gpg""

#   ]
# }