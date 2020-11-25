# Install operator life cycle manager
provider "kubernetes" {
  load_config_file = true
}

provider "kubectl" {
  load_config_file = true
}

resource "null_resource" "operator_lifecycle_manager" {

  count = var.keycloak_enabled ? 1 : 0

  provisioner "local-exec" {
    command = <<EOT
      kubectl apply -f ${var.crds_yaml}
      kubectl apply -f ${var.olm_yaml}
      kubectl rollout status -w deployment/olm-operator --namespace="olm"
      kubectl rollout status -w deployment/catalog-operator --namespace="olm"

      retries=50
      until [[ $retries == 0 || $new_csv_phase == "Succeeded" ]]; do
          new_csv_phase=$(kubectl get csv -n "olm" packageserver -o jsonpath='{.status.phase}' 2>/dev/null || echo "Waiting for CSV to appear")
          if [[ $new_csv_phase != "$csv_phase" ]]; then
              csv_phase=$new_csv_phase
              echo "Package server phase: $csv_phase"
          fi
          sleep 1
          retries=$((retries - 1))
      done

      if [ $retries == 0 ]; then
          echo "CSV \"packageserver\" failed to reach phase succeeded"
          exit 1
      fi

      kubectl rollout status -w deployment/packageserver --namespace="olm"
    EOT
    interpreter = ["/bin/bash", "-c"]
  }

  provisioner "local-exec" {

    when = destroy

    command = "./destroy_olm.sh"
    interpreter = ["/bin/bash", "-c"]
  }
}

#Install Keycloak Operator
#https://operatorhub.io/install/alpha/keycloak-operator.yaml
resource "null_resource" "keycloak_operator" {

  count = var.keycloak_enabled ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl apply -f https://operatorhub.io/install/alpha/keycloak-operator.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete -f https://operatorhub.io/install/alpha/keycloak-operator.yaml"
  }

  depends_on = [null_resource.operator_lifecycle_manager]
}


# Create a Keycloak cluster using the Operator
# kubectl create -f https://raw.githubusercontent.com/keycloak/keycloak-quickstarts/latest/operator-examples/mykeycloak.yaml
resource "null_resource" "keycloak" {

  count = var.keycloak_enabled ? 1 : 0

  provisioner "local-exec" {
    command = "kubectl create -f ./keycloak.yaml"
  }

  provisioner "local-exec" {
    when = destroy
    command = "kubectl delete -f keycloak/keycloak-cluster"
  }

  depends_on = [null_resource.keycloak_operator]
}
