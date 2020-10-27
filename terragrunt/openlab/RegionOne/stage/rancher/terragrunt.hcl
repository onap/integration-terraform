locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))
  region_vars  = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars     = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  backend              = local.account_vars.locals.backend
  backend_state        = local.account_vars.locals.backend_state
  region               = local.region_vars.locals.region
  environment          = local.env_vars.locals.environment
  ssh_private_key_path = local.env_vars.locals.ssh_private_key_path

  kubernetes_version      = local.env_vars.locals.kubernetes_version
  kubernetes_user         = local.env_vars.locals.kubernetes_user
  kubernetes_cluster_name = local.env_vars.locals.kubernetes_cluster_name
  kubernetes_home         = local.env_vars.locals.kubernetes_home

}

terraform {
  source = "git::https://gerrit.onap.org/r/integration/terraform//openlab/modules/kubernetes/rancher"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../compute/control"]
}

inputs = {
  backend                 = local.backend
  backend_state           = local.backend_state
  region                  = local.region
  environment             = local.environment
  ssh_private_key_path    = local.ssh_private_key_path
  kubernetes_version      = local.kubernetes_version
  kubernetes_user         = local.kubernetes_user
  kubernetes_cluster_name = local.kubernetes_cluster_name
  kubernetes_home         = local.kubernetes_home
}