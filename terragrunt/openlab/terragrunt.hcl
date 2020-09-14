locals {
  # Automatically load account-level variables
  account_vars = read_terragrunt_config(find_in_parent_folders("account.hcl"))

  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  # Extract the variables we need for easy access
  user_name     = local.account_vars.locals.user_name
  password      = local.account_vars.locals.password
  auth_url      = local.account_vars.locals.auth_url
  project_id    = local.account_vars.locals.project_id
  backend       = local.account_vars.locals.backend
  backend_state = local.account_vars.locals.backend_state
  region        = local.region_vars.locals.region
  environment   = local.environment_vars.locals.environment
}

remote_state {
  backend = local.backend

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }

  config = {
    bucket = "${local.backend_state}"
    prefix = "${path_relative_to_include()}/terraform.tfstate"
  }
}

# test/terragrunt.hcl
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "openstack" {
  user_name   = "${local.user_name}"
  tenant_name = "${local.user_name}"
  password    = "${local.password}"
  auth_url    = "${local.auth_url}"
  tenant_id   = "${local.project_id}"
  region      = "${local.region}"
}
EOF
}

# ---------------------------------------------------------------------------------------------------------------------
# GLOBAL PARAMETERS
# These variables apply to all configurations in this subfolder. These are automatically merged into the child
# `terragrunt.hcl` config via the include block.
# ---------------------------------------------------------------------------------------------------------------------

# Configure root level variables that all resources can inherit. This is especially helpful with multi-account configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.account_vars.locals,
  local.region_vars.locals,
  local.environment_vars.locals,
)
