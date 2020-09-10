locals {
  # Automatically load account-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  region      = local.region_vars.locals.region
  environment = local.env_vars.locals.environment
}

terraform {
  source = "git::https://gerrit.onap.org/r/integration/terraform//openlab/modules/openstack/securitygroup"
}

include {
  path = find_in_parent_folders()
}

inputs = {
  cluster_name = "${local.region}-${local.environment}"
}
