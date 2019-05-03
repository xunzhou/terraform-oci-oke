resource "helm_release" "prometheus" {
  chart      = "prometheus-operator"
  depends_on = ["null_resource.is_worker_active"]
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

  count = "${(var.install_prometheus == true) ? 1 : 0}"
}
