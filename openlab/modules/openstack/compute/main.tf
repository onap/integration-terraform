resource "openstack_compute_instance_v2" "nodes" {
  name      = "${var.cluster_name}-${var.node_name}-${count.index}"
  image_id  = data.openstack_images_image_v2.vm_image.id
  flavor_id = data.openstack_compute_flavor_v2.flavor.id
  key_pair  = data.terraform_remote_state.keypair.outputs.name
  network {
    name = data.terraform_remote_state.network.outputs.name
  }
  security_groups = [ data.terraform_remote_state.securitygroup.outputs.name ]

  user_data = var.user_data

  count = var.node_count
}

resource "openstack_compute_floatingip_v2" "floatingip" {
  pool = var.floating_ip_pool

  count = var.node_count
}

resource "openstack_compute_floatingip_associate_v2" "floatipassociation" {
  floating_ip = openstack_compute_floatingip_v2.floatingip[count.index].address
  instance_id = openstack_compute_instance_v2.nodes[count.index].id

  count = var.node_count
}
