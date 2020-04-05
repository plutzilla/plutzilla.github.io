---
layout: post
title: Continuous deployment to Digital Ocean Kubernetes cluster using Drone and Helm
---

<img src="{{ '/assets/img/posts/2020/k8s.jpg' | prepend:site.baseurl }}" alt="Kubernetes CI CD" class="img-responsive img-rounded" />

(image source: [https://dribbble.com/digitalocean](https://dribbble.com/digitalocean))

## Introduction

Hosting web applications and services in Kubernetes clusters is the common practice nowadays. Most hosting service providers offer managed Kubernetes services.

Digital Ocean is one of the hosting service providers, providing managed Kubernetes service for a resonable price and without cluster fees.

I have recently migrated from Google Kubernetes Engine (GKE) to DigitalOcean and want to share with you how to setup the continuous deployment pipeline to deploy service to DigitalOcean Kubernetes Service (DOKS).

## Prerequisites

I assume you already have the Continuous Integration pipeline which builds the application, packages it to Docker images and publishes them to the Container Registry.

Setting up a Kubernetes cluster (node pool) is also out of scope of this blogpost.

There are many great resources on the Internet regarding that: [DigitalOcean Kubetnetes Docs](https://www.digitalocean.com/docs/kubernetes/), [DOKS Github repo](https://github.com/digitalocean/DOKS), [Community website](https://www.digitalocean.com/community) etc.

## Helm

In this blogpost I will be using Helm to install the Ingress Controller and to deploy the web application to the Kubernetes cluster.

[Helm](https://helm.sh/) is a tool used to package and deploy Kubernetes applications (technically - multiple Kubernetes resource files). It is very useful as it:

* Uses a templating engine ([Go Sprig](https://masterminds.github.io/sprig/)) allowing to reuse the same Kubernetes resources (services, deployments, ingresses, service accounts etc.) with different values. Also, allowing to use conditional logic, loops etc. in the object files;
* Allows applying all objects in a single run (no need to run `kubectl apply -f <file>` multiple times). Also, allows release versioning and rollbacks;
* Provides ability to package (Helm packages are named `Charts`) and reuse the Kubernetes applications, also distribution via the repositories and package discovery via [Helm Hub](https://hub.helm.sh/);
* Provides the ability to define dependencies and install them along the Kubernetes application installation via Helm.

The Helm v3 stores all metadata in the Kubernetes cluster as the `Secret` objects and (unlike previous versions) does not require specific containers (Tiller) to be run in the namespace.

## Cluster setup

In order for the application hosted in Kubernetes to receive HTTP requests from the internet, it is needed to install the [Ingress Controller](https://kubernetes.io/docs/concepts/services-networking/ingress-controllers/).

[Nginx ingress controller](https://docs.nginx.com/nginx-ingress-controller/overview/) is one of the most popular ones. It can be installed using Helm very easily:

```bash
helm repo add nginx-stable https://helm.nginx.com/stable
helm repo update

helm install <INSTALLATION NAME> nginx-stable/nginx-ingress
```

Name can be automatically generated using a `--generate-name` parameter. `nginx-stable/nginx-ingress` is the Helm Chart from the repository.

For Ingress Controller to be run on multiple nodes, the replica count value should be overridden:

```bash
helm install --generate-name --set controller.replicaCount=2 nginx-stable/nginx-ingress
```

All configuration parameters can be found at [https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/](https://docs.nginx.com/nginx-ingress-controller/installation/installation-with-helm/).

## Deployment using Helm

For the deployment will need to:

* Authenticate to DigitalOcean;
* Obtain Kubernetes configuration (`kubeconfig` file);
* Perform deployment.

For authentication and `kubeconfig` generation the `doctl` command is used. It can be installed locally (i.e. as a [Snappy package](https://snapcraft.io/doctl)).

The DigitalOcean access token is needed to perform authentication instead of the personal credentials. The token can be generated in the user interface at [https://cloud.digitalocean.com/account/api/tokens](https://cloud.digitalocean.com/account/api/tokens).

The authentication is performed using a command:

```bash
doctl auth init --access-token <DIGITALOCEAN_ACCESS_TOKEN>
```

After successful authentication, `kubeconfig` file can be generated using a command (in tihs case it will be saved to `.kubeconfig`):

```bash
doctl k8s cluster kubeconfig show <CLUSTER_NAME> > .kubeconfig
```

Having a `kubeconfig` file which includes the user's token, we can perform the deployment of the Helm chart using a command:

```bash
helm upgrade --install --kubeconfig=.kubeconfig <INSTALLATION_NAME> /path/to/helm/chart
```

In this case the Chart is stored in the source code. If the Chart was published to the repository, it should have been added before.
Values to the Chart can be passed via `--set key=value` parameter, also having a Values file with multiple values, it can be provided using `-f /path/to/values/file.yaml` parameter.

## Deployment pipeline

I use [Drone](https://drone.io/) for Continuous Deployment. It provides deployment pipeline execution for container-based applications, and is availabe both as a service and as a product that can be installed and run on-premises.

There are other tools available, also source hosting services provide native CI/CD services ([GitLab CI](https://docs.gitlab.com/ee/ci/), [Github actions](https://github.com/features/actions)), so the pipelines should be similar when used in other tools.

In the deployment pipeline the following Docker images will be used:

* [digitalocean/doctl](https://hub.docker.com/r/digitalocean/doctl);
* [alpine/helm](https://hub.docker.com/r/alpine/helm).

Notes:

* `doctl` in the image is not included in `$PATH`. Overriding the `entrypoint`, we will need to provide full path to the doctl which is at `/app/doctl`.
* For the backwards compatibility is is advised to use the specific tag version instead of "latest". I will be using `digitalocean/doctl:1-latest` and `alpine/helm:3.1.2` at the time of writing.
* The DigitalOcean access token will be saved as a Secret in Drone and will be injected to the command from the environment variable.
* The deployment will be triggered using a `promotion` event and will deploy the Docker image tagged with the same name as the tag name in git. The event triggered from `tag` event which builds and publishes Docker image are out of scope (but should be included in the full pipeline).
* The Helm Chart contains the value `image`:

```yaml
image:
  repository: docker-owner/docker-repo
  tag: latest
```

The deployment deploys the pods with the containers from the defined image. We will override the `image.tag` in the deployment pipeline below. The deployment steps of the pipeline are the following:

```yaml
- name: Authenticate to DigitalOcean
  image: digitalocean/doctl:1-latest
  when:
    ref: [refs/tags/*]
    event: promote
    target: production
  environment:
    DIGITALOCEAN_ACCESS_TOKEN:
      from_secret: DIGITALOCEAN_ACCESS_TOKEN
  commands:
    - /app/doctl auth init --access-token $DIGITALOCEAN_ACCESS_TOKEN
    - /app/doctl k8s cluster kubeconfig show <CLUSTER_NAME> > .kubeconfig

- name: Deploy Helm Chart to Production
  image: alpine/helm:3.1.2
  when:
    ref: [refs/tags/*]
    event: promote
    target: production
  commands:
    - helm upgrade --install --kubeconfig=.kubeconfig -f /path/to/values/file.yaml --set image.tag=${DRONE_TAG##v} <INSTALLATION_NAME> /path/to/helm/chart

```

## Invoking deployment

Deployment event is meant to promote the specific build (in this case - build invoked on `tag` event) to the defined environment.

This event can be invoked using a `drone` CLI application (see [CLI reference](https://readme.drone.io/cli/build/drone-build-promote/) for more info) or the [REST API](https://docs.drone.io/api/builds/build_promote/):

```bash
drone build promote <owner>/<repository> <build number> <environment>
```

It can also be triggered from the source control management system if the webhooks are properly configured in the Repository Settings. In Github case it can be invoked via the [REST API](https://developer.github.com/v3/repos/deployments/):

```http
POST /repos/<OWNER>/<REPOSITORY>/deployments HTTP/1.1
Host: api.github.com
Accept: application/vnd.github.ant-man-preview+json
Content-Type: application/json
Authorization: token  <GITHUB ACCESS TOKEN>

{
  "ref": "<TAG NAME>",
  "payload": "",
  "description": "Promoting production environment to <TAG NAME>",
  "environment": "production"
}
```
