---
layout: post
title: Kubernetes basics
---

# What Kubernetes is

## Components and terminology

pod (po), service (svc), replicationcontroller (rc), deployment (deploy), replicaset (rs)

* workloads:
  * pods
  * controllers
    * deployments. Manages ReplicaSets
* services

## Tools (kubeadm, kubectl)

kubectl get

kubectl describe

kubectl apply

`kubectl exec` (kubectl exec <POD> /bin/bash -it)

https://kubernetes.io/docs/reference/kubectl/overview/

# Deploying an application in k8s

## Cluster preparation

## Building and publishing container image

`docker push <tag>`

`gcloud docker -- push gcr.io/<project id>/tag`

## Imperative configuration

`$ kubectl create deployment lescinskas-lt-deploy --image=eu.gcr.io/lescinskas-lt/nginx-server:latest`

`$ kubectl scale deployment lescinskas-lt-deploy --replicas=2`

```
$ kubectl get pods
NAME                                  READY   STATUS    RESTARTS   AGE
lescinskas-lt-deploy-78db55cc-w2nth   1/1     Running   0          115s
lescinskas-lt-deploy-78db55cc-xvtks   1/1     Running   0          12s
```

`$ kubectl set image deployment/lescinskas-lt-deploy nginx-server=eu.gcr.io/lescinskas-lt/nginx-server:latest`

`$ kubectl annotate deployments/lescinskas-lt-deploy kubernetes.io/change-cause="Updated to v2"`

`$ kubectl rollout history deploy/lescinskas-lt-deploy`

`$ kubectl rollout undo deployment lescinskas-lt-deploy` or `$ kubectl rollout undo deployment lescinskas-lt-deploy --to-revision 3`

`$ kubectl delete deployment lescinskas-lt-deploy; kubectl delete service lescinskas-lt-svc`

### Exposing pods

`$ kubectl expose deployment lescinskas-lt-deploy --type=LoadBalancer --port=80 --target-port=80 --external-ip=35.228.203.14 --name=lescinskas-lt-svc`
`$ kubectl expose deployment lescinskas-lt-deploy --type=LoadBalancer --port=80 --target-port=80 --name=lescinskas-lt-svc`

Takes labels from deployment and uses them as service selector.

Network-level (L4) load balancing. LoadBalancer exposes traffic to the Internet. For multiple services excessive external IP addresses can be used.

ClusterIP - internal access.

Ingress controllers are more powerul (L7 LB but more complicated), can do TLS termination, do rule-based routing etc. Ingress routes traffic to the Services therefore the Service (i.e. type=ClusterIP) still is needed. They expose HTTP(S) interface, but not other ports. For other ports, LoadBalancer should be used.

GKE allows ingress controller to be configured only for NodePort or LoadBalancer services. NodePort is preferred. It opens an internal port on all nodes and forwards the traffic to the defined backend port.
While ingress is being configured the errors can be displayed:

Some backend services are in UNKNOWN state
TLS error: SSL_ERROR_NO_CYPHER_OVERLAP
502 error

https://medium.com/google-cloud/kubernetes-nodeport-vs-loadbalancer-vs-ingress-when-should-i-use-what-922f010849e0
https://medium.com/@pczarkowski/kubernetes-services-exposed-86d45c994521

## Declarative configuration

# What's next

Secrets

Collecting metrics

Volumes

TLS configuration

Continuous Deployment

Application packaging, templating and deploying using Helm
