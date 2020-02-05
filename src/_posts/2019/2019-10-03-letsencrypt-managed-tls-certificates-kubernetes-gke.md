---
layout: post
title: Let's Encrypt managed TLS certificates in Kubernetes (GKE)
---

Securing the web application Internet traffic is one of the most common activities as the HTTPS is a must nowadays.
[Let's Encrypt](https://letsencrypt.org/) is becoming the most commonly used Certificate Authority providing the ability to automate the certificate issuing and renewal using [ACME](https://tools.ietf.org/html/rfc8555) protocol.

With growing Kubernetes (K8s) popularity, the web applications hosted in such environment meet the same requirements, but face different challenges; mostly due to not-so-trivial configuration and complicated certificate renewal.

If you are using Google Kubernetes Engine (GKE) on Google Cloud Platform (CGP), it is possible to use [managed Google TLS service](https://cloud.google.com/kubernetes-engine/docs/how-to/managed-certs) to automate the TLS provisioning and certificate renewal.

> It's important to mention though that such implementation is vendor (Google) specific and might result in the vendor lock, so keep that in mind.
>
> Also, this service is currently in Beta stage, so it has some limitations and potential issues.

The workflow of using the managed TLS certificates is relatively simple:

* Create K8s ManagedCertificate object(s)
* Configure the Ingress controller to use these certificates
* Make an HTTPS request to your domain
* Wait 10-20 minutes for magic to happen

The K8s `ManagedCertificates` object structure is the following (real world example from my blog):

```yaml
apiVersion: networking.gke.io/v1beta1
kind: ManagedCertificate
metadata:
  name: lescinskas-lt-cert
spec:
  domains:
  - lescinskas.lt
```

The object is created as usual in K8s - using `kubectl apply`.

If you need to configure the Ingress controller with multiple domains, each (sub)domain needs to be set up as a separate object (current service limitation).

After setting the `ManagedCertificates` up, the annotation needs to be added to the Ingress configuration and applied as usual:

```yaml
apiVersion: "extensions/v1beta1"
kind: Ingress
metadata:
  name: "lescinskas-lt-ingress"
  annotations:
    networking.gke.io/managed-certificates: "lescinskas-lt-cert,www-lescinskas-lt-cert"
...
```

Certificate objects are listed using comma as the separator. In this example I use both `lescinskas.lt` and `www.lescinskas.lt` domains to expose this website to the Internet.

During the provisioning the HTTPS version of the website will return various errors:

* `502` HTTP error
* `SSL_ERROR_NO_CYPHER_OVERLAP` TLS error
* `Some backend services are in UNKNOWN state` error in Google Cloud console

This should get automatically fixed within 10-20 minutes.

This is tolerable for new HTTPS setups, however for the web applications that already have some manual HTTPS configuration, such migration to this service will result in the certain downtime.
