resource "openstack_networking_secgroup_v2" "securitygroup" {
  name        = "${var.cluster_name}-securitygroup"
  description = "RKE security group"
}

resource "openstack_networking_secgroup_rule_v2" "securitygroup_rule" {
  direction         = "ingress"
  ethertype         = "IPv4"
  security_group_id = openstack_networking_secgroup_v2.securitygroup.id
}
