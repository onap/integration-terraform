provider "helm" {
  version = "~> 0.10.5"
  init_helm_home = true
  install_tiller = true
  service_account = var.service_account
  namespace    = var.namespace
  tiller_image = "gcr.io/kubernetes-helm/tiller:v2.17.0"

  kubernetes {
    config_path = "${var.kubernetes_home}/kube_config_cluster.yaml"
  }
}

provider "kubernetes" {
  version = ">= 1.13"
  load_config_file = true
}

# https://github.com/helm/charts/tree/master/stable/nfs-server-provisioner
resource "helm_release" "nfs" {
  count =  var.nfs_enabled ? 1 : 0


  chart = "stable/nfs-server-provisioner"
  name = "nfs"

  set {
    name = "storageClass.defaultClass"
    value = "true"
  }

  set {
    name = "storageClass.reclaimPolicy"
    value = "Delete"
  }

  depends_on = [kubernetes_cluster_role_binding.tiller]
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
