#!/bin/bash


# https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update
helm upgrade --install -f ./lescinskas-lt-nginx-ingress.values.yaml lescinskas-lt-nginx-ingress nginx-stable/nginx-ingress
