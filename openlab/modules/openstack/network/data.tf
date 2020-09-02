data "openstack_networking_network_v2" "egress_network" {
  name = var.network
}