output "floating_ips" {
  value = [openstack_compute_floatingip_associate_v2.floatipassociation.*.floating_ip]
}

output "fixed_ips" {
  value = [openstack_compute_instance_v2.nodes.*.access_ip_v4]
}

output "hostnames" {
  value = [openstack_compute_instance_v2.nodes.*.name]
}