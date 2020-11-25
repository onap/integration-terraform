terraform {
  required_providers {
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.7.0"
    }
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
    openstack = {
      source = "terraform-providers/openstack"
    }
  }

  required_version = ">= 0.13"
}