# Copyright 2017, 2019 Oracle Corporation and/or affiliates.  All rights reserved.
# Licensed under the Universal Permissive License v 1.0 as shown at http://oss.oracle.com/licenses/upl

resource "helm_release" "prometheus" {
  chart      = "prometheus-operator"
  depends_on = ["null_resource.is_worker_active", "null_resource.helm_init"]
  name       = "${var.prometheus_helm_release_name}"
  namespace  = "${var.prometheus_namespace}"
  provider   = "helm"
  repository = "${data.helm_repository.stable.metadata.0.name}"
  version    = "${var.prometheus_chart_version}"

  set {
    name  = "prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues"
    value = "false"
  }

  set {
    name  = "kubeDns.enabled"
    value = "true"
  }

  set {
    name  = "coreDns.enabled"
    value = "false"
  }

  set {
    name  = "kubeControllerManager.enabled"
    value = "false"
  }

  set {
    name  = "kubeEtcd.enabled"
    value = "false"
  }

  set {
    name  = "kubeScheduler.enabled"
    value = "false"
  }

  count = "${(var.create_bastion == true && var.install_prometheus == true) ? 1 : 0}"
}

data "template_file" "reconfigure_grafana_script" {
  template = "${file("${path.module}/scripts/reconfigure_grafana.template.sh")}"

  vars {
    prometheus_namespace         = "${var.prometheus_namespace}"
    prometheus_helm_release_name = "${var.prometheus_helm_release_name}"
  }

  count = "${(var.create_bastion == true  && var.install_prometheus == true) ? 1 : 0}"
}

resource null_resource "write_reconfigure_grafana" {
  connection {
    host        = "${var.bastion_public_ip}"
    private_key = "${file(var.ssh_private_key_path)}"
    timeout     = "40m"
    type        = "ssh"
    user        = "${var.image_operating_system == "Canonical Ubuntu"   ? "ubuntu" : "opc"}"
  }

  provisioner "file" {
    content     = "${data.template_file.reconfigure_grafana_script.rendered}"
    destination = "~/reconfigure_grafana.sh"
  }

  count = "${(var.create_bastion == true  && var.install_prometheus == true) ? 1 : 0}"
}

resource "local_file" "write_reconfigure_grafana" {
  content  = "${data.template_file.reconfigure_grafana_script.rendered}"
  filename = "${path.root}/scripts/reconfigure_grafana.sh"
  count    = "${var.install_prometheus == true   ? 1 : 0}"
}

data "template_file" "prometheus_script" {
  template = "${file("${path.module}/scripts/prometheus.template.sh")}"

  vars {
    prometheus_namespace         = "${var.prometheus_namespace}"
    prometheus_helm_release_name = "${var.prometheus_helm_release_name}"
  }

  count = "${var.install_prometheus == true   ? 1 : 0}"
}

resource "local_file" "write_prometheus_script" {
  content  = "${data.template_file.prometheus_script.rendered}"
  filename = "${path.root}/scripts/prometheus.sh"
  count    = "${var.install_prometheus == true   ? 1 : 0}"
}

data "template_file" "grafana_script" {
  template = "${file("${path.module}/scripts/grafana.template.sh")}"

  vars {
    prometheus_namespace         = "${var.prometheus_namespace}"
    prometheus_helm_release_name = "${var.prometheus_helm_release_name}"
  }

  count = "${var.install_prometheus == true   ? 1 : 0}"
}

resource "local_file" "write_grafana_script" {
  content  = "${data.template_file.grafana_script.rendered}"
  filename = "${path.root}/scripts/grafana.sh"
  count    = "${var.install_prometheus == true   ? 1 : 0}"
}
