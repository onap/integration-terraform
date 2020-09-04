terraform {
  required_providers {
    local = {
      source = "hashicorp/local"
    }
    null = {
      source = "hashicorp/null"
    }
    rke = {
      source = "registry.terraform.io/rancher/rke"
    }
  }
  required_version = ">= 0.13"
}
