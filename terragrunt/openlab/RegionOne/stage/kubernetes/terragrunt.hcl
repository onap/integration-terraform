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

  kubernetes_user         = local.env_vars.locals.kubernetes_user
  kubernetes_cluster_name = local.env_vars.locals.kubernetes_cluster_name
  kubernetes_home         = local.env_vars.locals.kubernetes_home

  # Helm
  service_account = local.env_vars.locals.service_account
  namespace       = local.env_vars.locals.namespace
}

terraform {
  source = "git::ssh://git@gitlab.yoppworks.com/onap/openlab.git//modules/kubernetes/kubernetes?ref=0.1.7"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../rancher"]
}

inputs = {
  backend              = local.backend
  backend_state        = local.backend_state
  region               = local.region
  environment          = local.environment
  ssh_private_key_path = local.ssh_private_key_path

  kubernetes_user         = local.kubernetes_user
  kubernetes_cluster_name = local.kubernetes_cluster_name
  kubernetes_home         = local.kubernetes_home

  service_account = local.service_account
  namespace       = local.namespace
}