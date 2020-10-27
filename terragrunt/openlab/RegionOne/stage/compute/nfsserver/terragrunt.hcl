locals {
  # Automatically load account-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  env_vars    = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  region      = local.region_vars.locals.region
  environment = local.env_vars.locals.environment
  network     = local.env_vars.locals.network
}

terraform {
  source = "git::https://gerrit.onap.org/r/integration/terraform//openlab/modules/openstack/compute"
}

include {
  path = find_in_parent_folders()
}

dependencies {
  paths = ["../../keypair", "../../network", "../../securitygroup"]
}

inputs = {

  environment  = local.environment
  cluster_name = "${local.region}-${local.environment}"

  node_name        = "nfsserver"
  image            = "ubuntu-18.04"
  flavor           = "m1.xlarge"
  floating_ip_pool = "external"
  # Read as File stream
  user_data  = file("nfs-server.sh")
  node_count = 1
}
