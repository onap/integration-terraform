# Set common variables for the environment. This is automatically pulled in in the root terragrunt.hcl configuration to
# feed forward to the child modules.
locals {
  environment = "" # name of the environment you use. e.g stage, prod or qa
  network     = "" # name of the network to connect with the Internet

  # Rancher and Kubernetes
  # To access a VM, 'ssh -i ssh_private_key_path kubernetes_user@one-of-the-external-ips'
  # a key pair for accessing VMs
  ssh_public_key       = "" # OpenSSH formated string is required
  ssh_private_key_path = "" # e.g ~/.ssh/id_rsa

  kubernetes_version      = "v1.15.11-rancher1-2" # rke version. please, check the correct rke version at https://github.com/rancher/rke/releases/
  kubernetes_user         = "ubuntu"
  kubernetes_cluster_name = "rke_cluster"

  kubernetes_home = "${get_parent_terragrunt_dir()}"

  # Helm
  service_account = "tiller"
  namespace       = "kube-system"
}