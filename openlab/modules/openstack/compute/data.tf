data "terraform_remote_state" "keypair" {
  backend = var.backend
  config = {
    bucket      = var.backend_state
    prefix      = "${var.region}/${var.environment}/keypair/terraform.tfstate"
  }
}

data "terraform_remote_state" "network" {
  backend = var.backend
  config = {
    bucket      = var.backend_state
    prefix      = "${var.region}/${var.environment}/network/terraform.tfstate"
  }
}

data "terraform_remote_state" "securitygroup" {
  backend = var.backend
  config = {
    bucket      = var.backend_state
    prefix      = "${var.region}/${var.environment}/securitygroup/terraform.tfstate"
  }
}

data "openstack_images_image_v2" "vm_image" {
  name = var.image
}

data "openstack_compute_flavor_v2" "flavor" {
  name = var.flavor
}

data "openstack_networking_network_v2" "egress_network" {
  name = var.network
}

