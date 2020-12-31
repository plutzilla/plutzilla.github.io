---
layout: post
title: Kubernetes Service Monitoring in Prometheus
---

## Metrics server

https://raw.githubusercontent.com/digitalocean/marketplace-kubernetes/master/stacks/metrics-server/deploy.sh

## Prometheus operator

https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack

https://raw.githubusercontent.com/digitalocean/marketplace-kubernetes/master/stacks/kube-prometheus-stack/deploy.sh

DO monitoring stack: https://github.com/digitalocean/marketplace-kubernetes/blob/master/stacks/monitoring/deploy.sh

Exposing Grafana:

```bash
kubectl port-forward svc/kube-prometheus-stack-grafana 8081:80 -n kube-prometheus-stack
```

Exposing Prometheus:

```bash
kubectl port-forward svc/kube-prometheus-stack-prometheus 9090:9090 -n kube-prometheus-stack
```

### Service discovery

Service monitor selector:

```bash
kubectl get prometheus kube-prometheus-stack-prometheus -o yaml --namespace kube-prometheus-stack
```

The following manifect of a `prometheus` CRD will be displayed:

```yaml
...
  serviceMonitorNamespaceSelector: {}
  serviceMonitorSelector:
    matchLabels:
      release: kube-prometheus-stack
```

Prometheus operator Helm values:

```yaml
grafana:
  persistence:
    enabled: true
    size: 10Gi
prometheus:
  prometheusSpec:
    serviceMonitorSelectorNilUsesHelmValues: false
```

https://github.com/helm/charts/blob/7e45e678e39b88590fe877f159516f85f3fd3f38/stable/prometheus-operator/templates/prometheus/prometheus.yaml#L101

```yaml
{{- if .Values.prometheus.prometheusSpec.serviceMonitorSelector }}
  serviceMonitorSelector:
{{ toYaml .Values.prometheus.prometheusSpec.serviceMonitorSelector | indent 4 }}
{{ else if .Values.prometheus.prometheusSpec.serviceMonitorSelectorNilUsesHelmValues  }}
  serviceMonitorSelector:
    matchLabels:
      release: {{ $.Release.Name | quote }}
{{ else }}
  serviceMonitorSelector: {}
{{- end }}
```

## NginX ingress controller

https://github.com/kubernetes/ingress-nginx/tree/master/charts/ingress-nginx

Helm values:

```yaml
controller:
  replicaCount: 2
  metrics:
    enabled: true
    service:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/port: "10254"
    serviceMonitor:
      enabled: true
      namespaceSelector:
        any: true
      # additionalLabels:
      #   release: kube-prometheus-stack
```

Installation:

```sh
helm upgrade --install -f ./ingress-nginx.yaml ingress-nginx ingress-nginx/ingress-nginx
```
