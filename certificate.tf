resource "kubectl_manifest" "certificate_grafana" {
  yaml_body = templatefile("${path.root}/kubernetes/helm/cert-manager/manifests/certificate-grafana.yaml", {
    grafana_hostname = var.grafana_hostname
  })
  depends_on = [kubectl_manifest.cluster_issuer]
}

resource "kubectl_manifest" "certificate_prometheus" {
  yaml_body = templatefile("${path.root}/kubernetes/helm/cert-manager/manifests/certificate-prometheus.yaml", {
    prometheus_hostname = var.prometheus_hostname
  })
  depends_on = [kubectl_manifest.cluster_issuer]
}