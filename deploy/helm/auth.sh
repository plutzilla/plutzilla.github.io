#!/bin/bash
doctl auth init
doctl kubernetes cluster kubeconfig save do-k8s-lescinskas-lt-cluster
