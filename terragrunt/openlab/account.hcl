# Set account-wide variables. These are automatically pulled in to configure the remote state bucket in the root
# terragrunt.hcl configuration.
# For Openstack, please fill in the values below
locals {
  user_name     = "${get_env("user_name", "")}" # Expose environmental variables for your account
  password      = "${get_env("password", "")}"
  project_id    = "${get_env("project_id", "")}"
  auth_url      = "${get_env("auth_url", "")}"
  backend       = "" # Remote state backend. gcs for google or s3 for Amazon
  backend_state = "" # GCP storage bucket or AWS S3
}
