# Copyright 2017, 2019 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

provider "helm" {
  kubernetes {
    config_path = "${path.root}/generated/kubeconfig"
  }
}

data "helm_repository" "stable" {
  name = "stable"
  url  = "https://kubernetes-charts.storage.googleapis.com"
}

# https://github.com/terraform-providers/terraform-provider-helm/pull/185
resource "null_resource" "helm_init" {
  provisioner "local-exec" {
    command = "helm init --client-only"
  }
  count = "${var.install_prometheus == true ? 1 : 0}"
}
