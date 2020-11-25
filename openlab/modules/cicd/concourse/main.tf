provider "helm" {
  version = "1.0.0"
}

# https://github.com/concourse/concourse-chart
resource "helm_release" "concourse" {
  count = var.concourse_enabled ? 1 : 0

  chart = "concourse/concourse"
  name = "concourse"

  dependency_update = true

  # values = ["${file("values.yaml")}"]
}