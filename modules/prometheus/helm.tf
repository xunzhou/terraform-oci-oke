provider "helm" {
  kubernetes {
    config_path = "${path.root}/generated/kubeconfig"
  }
}

data "helm_repository" "stable" {
    name = "stable"
    url = "https://kubernetes-charts.storage.googleapis.com"
}