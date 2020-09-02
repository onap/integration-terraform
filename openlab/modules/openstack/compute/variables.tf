variable "cluster_name" {
  description = "A name for the cluster"
  type = string
}

variable "backend" {}
variable "backend_state" {}
variable "region" {}
variable "environment" {}

variable "node_name" {}
variable "image" {}
variable "flavor" {}
variable "network" {}
variable "floating_ip_pool" {}
variable "user_data" {}

variable "node_count" {}
