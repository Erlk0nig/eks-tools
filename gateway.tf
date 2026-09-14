resource "kubectl_manifest" "gateway_class" {
  yaml_body  = file("${path.root}/kubernetes/manifests/gateway-class.yaml")
  depends_on = [kubectl_manifest.envoy_proxy, kubectl_manifest.certificate_grafana, kubectl_manifest.certificate_prometheus]
}

resource "kubectl_manifest" "gateway" {
  yaml_body = templatefile("${path.root}/kubernetes/manifests/gateway.yaml", {
    grafana_hostname    = var.grafana_hostname
    prometheus_hostname = var.prometheus_hostname
  })
  depends_on = [kubectl_manifest.gateway_class]
}

resource "kubectl_manifest" "http_route_grafana" {
  yaml_body = templatefile("${path.root}/kubernetes/manifests/grafana-httproute.yaml", {
    grafana_hostname = var.grafana_hostname
  })
  depends_on = [kubectl_manifest.gateway]
}

resource "kubectl_manifest" "http_route_prometheus" {
  yaml_body = templatefile("${path.root}/kubernetes/manifests/prometheus-httproute.yaml", {
    prometheus_hostname = var.prometheus_hostname
  })
  depends_on = [kubectl_manifest.gateway]
}