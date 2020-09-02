provider "helm" {
  version = "~> 0.10.0"
  init_helm_home = true
  install_tiller = true
  service_account = var.service_account
  namespace    = var.namespace
  tiller_image = "gcr.io/kubernetes-helm/tiller:v2.16.6"

  kubernetes {
    config_path = "${var.kubernetes_home}/kube_config_cluster.yaml"
  }
}

provider "kubernetes" {
  version = ">= 1.10"
  load_config_file = true
}

resource "kubernetes_service_account" "tiller" {
  automount_service_account_token = true

  metadata {
    name = var.service_account
    namespace = var.namespace
  }
}

resource "kubernetes_cluster_role_binding" "tiller" {
  metadata {
    name = "tiller"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind      = "ClusterRole"
    name      = "cluster-admin"
  }

  subject {
    kind      = "ServiceAccount"
    name      = kubernetes_service_account.tiller.metadata.0.name
    namespace = kubernetes_service_account.tiller.metadata.0.namespace
  }

  provisioner "local-exec" {
    command = "helm init --service-account ${var.service_account};kubectl -n ${var.namespace} rollout status deployment/tiller-deploy"
  }
}
