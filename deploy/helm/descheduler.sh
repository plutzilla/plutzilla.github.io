#!/bin/bash


# https://github.com/kubernetes-sigs/descheduler
# Helm chart: https://github.com/kubernetes-sigs/descheduler/blob/master/charts/descheduler/README.md
# Helm values:     https://github.com/kubernetes-sigs/descheduler/blob/master/charts/descheduler/values.yaml

# Descheduler must be installed in kube-system namespace
helm repo add descheduler https://kubernetes-sigs.github.io/descheduler/
helm upgrade --install --version v0.18 --namespace kube-system lescinskas-lt-descheduler descheduler/descheduler-helm-chart
