---
layout: post
title: Moving from HTTP to HTTPS
---

<img src="{{ '/assets/img/posts/2019/https.png' | prepend:site.baseurl }}" alt="HTTPS" class="img-responsive img-rounded" />

Currently HTTPS (HTTP over TLS) is the de-facto protocol for accessing content in the web. By utilizing public-key infrastructure this protocol ensures the **confidentiality** and **integrity** of the data in-transit and the **authenticity** of the website.

While HTTPS brings many benefits for all parties and is being promoted by the browser vendors and various organizations, its adoption for a large enterprises, especially operating number of domains, can be complicated.

This post is the summary of a practical experience obtained from migrating one large web system to HTTPS.

# Preparation and enabling HTTPS

## Defining the scope

If you operate more that one domain, it is important to define the scope - for which products the HTTPS will be forced.

If the web application loads the assets (images, CSS stylesheets, JS scripts, fonts etc.) from HTTP origins, this would result in the Mixed Content. Depending on the Mixed Content type (active, passive) it result in the incorrect behaviour or incorrect visual representation of the application, therefore such changes need to be taked with a proper care and monitoring of the potential impact.
The W3C Reporting API can be utilized to identify the impact and to adjust the scope of the change.

## Planning

The sample activity plan for the implementation:

* Enabling HTTPS
  * Obtaining TLS certificate
  * Configuring TLS
* Reporting and testing
  * CSP configuration, tuning
  * Manual testing
  * Verifying and increasing TTL for reporting
* Forcing HTTPS
  * Upgrading insecure requests
  * Configuring HTTPS redirects
  * Configuring cookies
  * Enabling Strict Transport Security (HSTS)
  * Verifying and increasing TTL for HSTS

There might be additional steps needed. Also, it makes sense to run these activities in Development, Testing and Staging environments first and then replicate the configuration to Production.

For us it took approximately 3 months to do the smooth and safe transition to HTTPS.

# Enabling HTTPS

To enable HTTPS in the web system, it is needed to obtain the TLS certificate from the Certificate Authority (CA) and to configure the HTTP(S) server or proxy to support it.

## Obtaining certificate

The TLS certificate can be bough from one of many CAs or to get one for free from the non-profit CA [Let's Encrypt](https://letsencrypt.org/).

Let's Encrypt utilizes the Automated Certificate Management Environment (ACME) protocol to automate the certficate issuing, validation and renewal, therefore the certificate validity is 3 months, thus should be obtained and renewed in the automated manner. The same ACME protocol is used by other CAs as well.

The other CAs issue TLS certificates that are valid for a longer time (1 or 2 years usually), therefore in certain (premature) environments this can be more suitable option.

Also, TLS encryption can be provided out-of-the-box as a managed service. As an example, Cloudflare provides a [TLS proxy service](https://www.cloudflare.com/ssl/), Google Cloud Platform provides managed TLS service, that is also [available for Kubernetes]({%post_url 2019/2019-10-03-letsencrypt-managed-tls-certificates-kubernetes-gke %}).

## TLS configuration

The certificate itself does not ensure the security - it enables the client to verify the server's authenticity and to perform the TLS handshake.

The actual TLS setup security depends on the configuration of the HTTPS server, in particular which TLS versions and cipher suits are supported by the server.

To ensure the consistent configuration of the HTTPS services, it makes sense to serve all HTTPS traffic through the single TLS proxy. It can be both hosted on-premise or the online TLS service can be used.

The [TLS configuration test](https://www.ssllabs.com/ssltest/) can be used to evaluate the security of both certificate and the server setup. I suggest to aim for at least "A" grade unless some specific exeptions are needed (i.e. RC4 cipher support, which is used in old MSIE browser versions).

The continuous improvement of the HTTPS server setup is needed as new weaknesses are discovered in the certain TLS protocol versions and cipher suits, thus new configuration options emerge.
There's a good quick summary of [protocol and cipher security in Wikipedia](https://en.wikipedia.org/wiki/Transport_Layer_Security#Cipher).

# Reporting and Testing

As the ultimate target is to fully migrate to HTTPS, there is a need to be safe that such change will not introduce any regression and faulty web application behavior.

## Content Security Policy (CSP) violation reporting



## Network Error Logging (NEL) reporting

## Manual testing

ModHeaders extension

# Forcing HTTPS

## Upgrading insecure requests

## HTTP redirects

Search engines, S2S (non-UA) integrations, UAs that do not support this CSP level.

## Secure cookies

secure flag, `__Secure_` prefix

## HTTP Strict Transport Security (HSTS)

# Further actions

## HSTS Preload

## Tuning CSP

## Moving to HTTP2

(Chrome Console:)
HTTP 307
Non-Authoritative-Reason: HSTS

As of October 2019 the specification is still a [Candidate Recommendation](https://www.w3.org/TR/upgrade-insecure-requests/) and [lack support](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/upgrade-insecure-requests#Browser_compatibility) from MSIE and Edge browsers.

