resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
  depends_on = [helm_release.cert_manager]
}

resource "helm_release" "kube_prometheus_stack" {
  name       = "kube-prometheus-stack"
  namespace  = kubernetes_namespace.monitoring.metadata[0].name
  chart      = "kube-prometheus-stack"
  repository = "https://prometheus-community.github.io/helm-charts"
  version    = "69.3.2" # Specify the desired version

  values     = [file("${path.module}/kubernetes/helm/kube-prometheus-stack/values.yaml")]
  depends_on = [kubernetes_namespace.monitoring]
}