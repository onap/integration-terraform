# If your terraform version is < 0.13-beta, manual installation is needed.
# https://github.com/rancher/terraform-provider-rke
provider "rke" {}

locals {
  control_node = [for ip in (flatten(data.terraform_remote_state.control_plane_floating_ips.outputs.floating_ips)): {
      address = ip
      role = "control"
   }]
  worker_node = [for ip in (flatten(data.terraform_remote_state.worker_node_floating_ips.outputs.floating_ips)): {
      address = ip
      role = "worker"
  }]

  all_node = concat(local.control_node, local.worker_node)
}

resource "rke_cluster" "cluster" {
  kubernetes_version = var.kubernetes_version
  cluster_name = var.kubernetes_cluster_name

  dynamic nodes {

    for_each = local.all_node

    content {
      address = nodes.value.address
      user = var.kubernetes_user
      role = (nodes.value.role == "control") ? [ "controlplane", "etcd" ] : ["worker"]
    }
  }

  # You have to have private key on your machine excuting terraform
  # An Openstack keypair is generated and stored within the remote state at
  # "${var.region}/${var.environment}/keypair/terraform.tfstate"
  ssh_key_path = var.ssh_private_key_path

  disable_port_check = false

  depends_on = [null_resource.wait-for-docker]
}

resource "local_file" "kube_cluster_yaml" {
  filename = "${var.kubernetes_home}/kube_config_cluster.yaml"
  sensitive_content = rke_cluster.cluster.kube_config_yaml
}

resource "null_resource" "wait-for-docker" {
  provisioner "local-exec" {
    # wait untill VM's bootstrapping's done
    # If your VMs for Computing node have finished bootstrapping already,
    # you may not need this waiting time
    command = "sleep 120"
  }
}
