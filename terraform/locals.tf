locals {
  all_nodes = concat(var.master_nodes, var.worker_nodes)
}