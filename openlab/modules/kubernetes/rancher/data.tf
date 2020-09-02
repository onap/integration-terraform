data "terraform_remote_state" "control_plane_floating_ips" {
  backend = var.backend
  config = {
    bucket      = var.backend_state
    prefix      = "${var.region}/${var.environment}/compute/control/terraform.tfstate"
  }
}

data "terraform_remote_state" "worker_node_floating_ips" {
  backend = var.backend
  config = {
    bucket      = var.backend_state
    prefix      = "${var.region}/${var.environment}/compute/worker/terraform.tfstate"
  }
}
