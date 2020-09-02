locals {
  # Automatically load account-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  region      = local.region_vars.locals.region
  environment = local.env_vars.locals.environment
  network     = local.env_vars.locals.network
}

terraform {
  source = "git::ssh://git@gitlab.yoppworks.com/onap/openlab.git//modules/openstack/network?ref=0.1.7"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name = "${local.region}-${local.environment}"
  network      = local.network
}
