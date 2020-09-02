output "ips" {
  value = local.all_node
}

output "kube_config_file" {
  value = local_file.kube_cluster_yaml.filename
}