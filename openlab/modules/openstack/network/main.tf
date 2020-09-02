resource "openstack_networking_network_v2" "network" {
  name              = "${var.cluster_name}-network"
  admin_state_up    = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name        = "${var.cluster_name}-subnet"
  network_id  = openstack_networking_network_v2.network.id
  cidr        = "192.168.64.0/24"
  ip_version  = 4
  gateway_ip  = "192.168.64.1"
  enable_dhcp = "true"
  dns_nameservers = [ "8.8.8.8", "8.8.4.4" ]
}

resource "openstack_networking_router_v2" "router" {
  name                = "${var.cluster_name}-router"
  admin_state_up      = true
  external_network_id = data.openstack_networking_network_v2.egress_network.id
}

resource "openstack_networking_router_interface_v2" "router_interface" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}