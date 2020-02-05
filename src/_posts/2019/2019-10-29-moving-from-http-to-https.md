---
layout: post
title: Moving from HTTP to HTTPS
---

<img src="{{ '/assets/img/posts/2019/https.png' | prepend:site.baseurl }}" alt="HTTPS" class="img-responsive img-rounded" />

Currently HTTPS (HTTP over TLS) is the de-facto protocol for accessing content in the web. By utilizing public-key infrastructure this protocol ensures the **confidentiality** and **integrity** of the data in-transit and the **authenticity** of the website.

While HTTPS brings many benefits for all parties and is being promoted by the browser vendors and various organizations, its adoption for a large enterprises, especially operating number of domains, can be complicated.

This post is the summary of a practical experience obtained from migrating one large web system to HTTPS.

## Preparation and enabling HTTPS

### Defining the scope

If you operate more that one domain, it is important to define the scope - for which product(s) the HTTPS will be forced.

If the web application loads the assets (images, CSS stylesheets, JS scripts, fonts etc.) from HTTP origins, this would result in the Mixed Content. Depending on the Mixed Content type (active, passive) it would cause the incorrect behaviour or incorrect visual representation of the application, therefore such changes need to be taked with a proper care and monitoring of the potential impact.
The W3C Reporting API can be utilized to identify the impact and to adjust the scope of the change.

### Planning

The sample activity plan for the implementation:

* Enabling HTTPS
  * Obtaining TLS certificate
  * Configuring TLS
* Reporting and testing
  * CSP configuration, tuning
  * Manual testing
  * Verifying and increasing TTL for NEL reporting
* Forcing HTTPS
  * Upgrading insecure requests
  * Configuring HTTPS redirects
  * Configuring cookies
  * Enabling Strict Transport Security (HSTS)
  * Verifying and increasing TTL for HSTS

There might be additional steps needed. Also, it makes sense to run these activities in Development, Testing and Staging environments first and then replicate the configuration to Production.

For us it took approximately 3 months to do the smooth and safe transition to HTTPS.

## Enabling HTTPS

To enable HTTPS in the web system, it is needed to obtain the TLS certificate from the Certificate Authority (CA) and to configure the HTTP(S) server or proxy to support it.

### Obtaining certificate

The TLS certificate can be bough from one of many CAs or obtained for free from the non-profit CA [Let's Encrypt](https://letsencrypt.org/).

Let's Encrypt utilizes the Automated Certificate Management Environment (ACME) protocol to automate the certficate issuing, validation and renewal, therefore the certificate validity is 3 months, thus should be obtained and renewed in the automated manner. The same ACME protocol is used by other CAs as well.

TLS certificates issued by other CAs are valid for a longer time (1 or 2 years usually), therefore in certain (premature) environments this can be more suitable option.

Also, TLS encryption can be provided out-of-the-box as a managed service. As an example, Cloudflare provides a [TLS proxy service](https://www.cloudflare.com/ssl/), Google Cloud Platform provides managed TLS service, that is also [available for Kubernetes]({%post_url 2019/2019-10-03-letsencrypt-managed-tls-certificates-kubernetes-gke %}).

### TLS configuration

The certificate itself does not ensure the security - it enables the client to verify the server's authenticity and to perform the TLS handshake.

The actual TLS setup security depends on the configuration of the HTTPS server, in particular which TLS versions and cipher suits are supported by the server.

To ensure the consistent configuration of the HTTPS services, it makes sense to serve all HTTPS traffic through the single TLS proxy. It can be both hosted on-premise or the online TLS service can be used.

The [TLS configuration test](https://www.ssllabs.com/ssltest/) can be used to evaluate the security of both certificate and the server setup. I suggest to aim for at least "A" grade unless some specific exeptions are needed (i.e. RC4 cipher support, which is used in old MSIE browser versions).

The continuous improvement of the HTTPS server setup is needed as new weaknesses are discovered in the certain TLS protocol versions and cipher suits, thus new configuration options emerge.
There's a good quick summary of [protocol and cipher security in Wikipedia](https://en.wikipedia.org/wiki/Transport_Layer_Security#Cipher).

## Reporting and Testing

As the ultimate target is to fully migrate to HTTPS, there is a need to be safe that such change will not introduce any regression and faulty web application behavior.

### Content Security Policy (CSP) violation reporting

One of the main means to ensure HTTP transport security is by utilizing [Content Security Policy](https://developer.mozilla.org/en-US/docs/Web/HTTP/CSP) (CSP). Using CSP the web browsers are instructed to control the origins that web application can load assets from.

CSP can work both in `enforced` mode (User Agents are blocking certain requests) and in `report-only` mode (violations are logged). The latter mode can be used to safely define a desired set of CSP directives and to perform a dry-run without actual negative impact to the end users.

The CSP directive configuration very much depends on the web application structure and the origins that are (and should be) allowed to load the assets from.

The violations can be logged to the Reporting service, [report-uri.com](https://report-uri.com) being one of the popular ones, run by [Scott Helme](https://scotthelme.co.uk/) and [Troy Hunt](https://www.troyhunt.com/) - the well-known figures in the Application Security universe.

I suggest to start from the very strict policy (i.e. `default-src 'self'`) and to loosen it with the needed origins (i.e. CDN domains) and with the directives that fixing costs too much to be included to scope of the mirgation to HTTPS project (i.e. `'unsafe-inline'`).
Just be aware that once you make changes in production, your logs might get filled REALLY quickly.

After number of CSP alteration we defined the safe policy (suitable for our web application) to be used in the `report-only` mode. This is how the HTTP response header looks like for such policy:

```
Content-Security-Policy-Report-Only: default-src data: https: 'unsafe-inline' 'unsafe-eval' 'report-sample'; report-uri https://EXAMPLE.report-uri.com/r/d/csp/reportOnly
```

While being a safe to be used in the production within a scope of a HTTPS migration, such CSP is **NOT** secure, especially `data:`, `'unsafe-inline'` and `'unsafe-eval'` origins. However, if these origins are used in the application, it needs to be refactored in order to exclude it from the CSP origin whitelist.

The CSP reports are submitted in JSON format. The report example:

```json
{
    "csp-report": {
        "blocked-uri": "eval",
        "column-number": 2718,
        "document-uri": "https://www.example.com/some-uri",
        "line-number": 1,
        "original-policy": "default-src https:; script-src https: 'unsafe-inline' 'report-sample'; report-uri https://EXAMPLE.report-uri.com/r/d/csp/reportOnly",
        "script-sample": "function anonymous(\n) {\nreturn this.GetP…",
        "source-file": "https://www.example.com/document-with-a-csp-violation",
        "violated-directive": "script-src"
    }
}
```

Analysing and tuning the CSP gives a good overview of the dependencies of your application(s) and lets you adjust the scope of the migration to HTTPS project.

For example, we found out that some of our applications load assets from the user-defined origins and introducing the restrictions might result in the undesired behavior. Therefore we left such applications out of scope (HTTPS is enabled but not forced), accepting the risk of a mixed content-based threats.

### Network Error Logging (NEL) reporting

[Network Error Logging](https://www.w3.org/TR/network-error-logging/) is a modern standard allowing web browsers to report the Network Errors by utilizing [W3C Reporting API](https://www.w3.org/TR/reporting/).
Scott Helme has a [comprehensive blogpost](https://scotthelme.co.uk/network-error-logging-deep-dive/) about NEL.

The following TLS errors can be reported:

```
tls.version_or_cipher_mismatch
    The TLS connection was aborted due to version or cipher mismatch
tls.bad_client_auth_cert
    The TLS connection was aborted due to invalid client certificate
tls.cert.name_invalid
    The TLS connection was aborted due to invalid name
tls.cert.date_invalid
    The TLS connection was aborted due to invalid certificate date
tls.cert.authority_invalid
    The TLS connection was aborted due to invalid issuing authority
tls.cert.invalid
    The TLS connection was aborted due to invalid certificate
tls.cert.revoked
    The TLS connection was aborted due to revoked server certificate
tls.cert.pinned_key_not_in_cert_chain
    The TLS connection was aborted due to a key pinning error
tls.protocol.error
    The TLS connection was aborted due to a TLS protocol error
tls.failed
    The TLS connection failed due to reasons not covered by previous errors
```

The errors can indicate wrong configuration, use of expired or revoked TLS certificate and the misuse or potential TLS-based attack scenarios.

The errors can be logged to the aforementioned report-uri.com service by adding the certain HTTP response headers (replace term "EXAMPLE" with your configured one):

```
Report-To: {"group":"default","max_age":604800,"endpoints":[{"url":"https://EXAMPLE.report-uri.com/a/d/g"}],"include_subdomains":true}
NEL: {"report_to":"default","max_age":604800,"include_subdomains":true}
```

In this example the `max_age` directive is set to 7 days (604 800 seconds). This is the time for which web browser stores this setting for a certain domain (or for all subdomains as well as in the example above).
After testing period the `max_age` attribute should be increased to a much longer period (i.e. 365 days / 31 536 000 seconds).

### Manual testing

While `report-only` CSP can be deployed in production and over time most violations will get reported, there are certain cases when manual testing is needed, for example:

* Internal applications or subsystems with restricted access
* Specific browser extensions are used and reports show blocked `chrome-extension` or similar URI

Manual testing provides the ability not only to report the violations, but to see the actual impact.
Therefore during the manual testing it is needed to use the `enforced` CSP mode which actually blocks requests. Due to potential negative impact it obviously cannot be done for all users.

One of the easiest ways is to use the browser extension to modify the HTTP headers.
[ModHeaders](https://bewisse.com/modheader/) extension is available for [Chrome](https://chrome.google.com/webstore/detail/modheader/idgpnmonknjnojddfkpgkljpfnnfcklj?hl=en) and [Firefox](https://addons.mozilla.org/en-US/firefox/addon/modheader-firefox/), allowing to perform the manual test.

Read further section to get the actual CSP policy which can be used along with this extension for testing.

## Forcing HTTPS

After the web application(s) are accessible via HTTPS, testing is performed, scope for forcing HTTPS is clarified and the CSP policy is defined, it is time to move the the second stage - force the HTTPS for these applications.

### Upgrading insecure requests

[Upgrade insecure requests](https://www.w3.org/TR/upgrade-insecure-requests/) is a CSP directive informing web browsers to seamlessly upgrade all requests from the web application to use HTTPS even if the HTTP is used in the application code.
As the result it reduces the mixed content likelihood and improves the application security with very little effort.

Under the hood it works this way: the browser indicates the support of this feature via request HTTP header

```
Upgrade-insecure-requests: 1
```

The upgrade itself is set via response HTTP header:

```
Content-Security-Policy: upgrade-insecure-requests; default-src https:
```

Combined with the previously defined CSP policy, we can now define and activate the final CSP which works in the `enforced` mode:

```
Content-Security-Policy: upgrade-insecure-requests; default-src data: https: 'unsafe-inline' 'unsafe-eval' 'report-sample'; report-uri https://EXAMPLE.report-uri.com/r/d/csp/reportOnly
```

> There are some caveats though for using CSP upgrade-insecure-requests: at the time of writing (October 2019) the specification is still a Candidate Recommendation and [lacks support](https://developer.mozilla.org/en-US/docs/Web/HTTP/Headers/Content-Security-Policy/upgrade-insecure-requests#Browser_compatibility) from MSIE and Edge browsers. Also it does not protect against initial insecure requests, which can eavesdropped or intercepted.
> Therefore we need additional measures (HTTP redirects and HTTP Strict Transport Security) to overcome these limitations.

### HTTP redirects

There are cases when the `upgrade-insecure-requests` does not ensure the protocol upgrade:

* Web browsers not supporting this CSP directive (MSIE, Edge)
* Search engines and web crawlers (robots)
* Service-to-service integrations (when the User Agent is not a web browser)

For such cases, instead of serving the HTML content via HTTP, we need to perform the HTTP to HTTPS redirect. This can be done by responding the `301`, `302`, `307` or `308` HTTP Response code with the `Location` header containing the URL with upgraded HTTP scheme.

`301` and `302` response codes work well for `GET` requests, but browsers do not resend full HTTP body if the method is `POST` or other method containing the HTTP body. `308` is not supported by legacy browsers.

Therefore the best option in this case is to use `HTTP 307 Temporary Redirect` response.

### Secure cookies

HTTP cookies can be sent both via secure and insecure connections. As usually the session identifiers are stored in cookies, exposing this information via unencrypted network might result in the session hijacking attacks. In order to limit the cookies to be sent via HTTPS only, it is needed to set the `secure` cookie attribute.

Another modern (but not yet standartized) cookie improvement is [cookie prefixes](https://tools.ietf.org/html/draft-ietf-httpbis-cookie-prefixes-00).
In order to allow the cookies to be set only from the secure connection, it is suggested to add the `__Secure-` prefix to the cookie name.
However this change would require the changes in the application code, so cookies named i.e. `session_id` would be renamed to `__Secure-session_id`.

The cookie prefixes are not yet supported by MSIE and Edge browsers, but this is not a breaking change, so still worth implementing.

### HTTP Strict Transport Security (HSTS)

In order to reduce the likelihood of protocol downgrade attacks, the HTTP Strict Transport Security (HSTS) should be used.
It instructs web browsers to remember that all connections to certain (sub)domains need to be done **only** using HTTPS.

It is done by sending the HTTP response header:

```
Strict-Transport-Security: max-age=31536000
```

where `31536000` means the `365` days period in seconds for which this setting should be remembered by the particular user's web browser.

I recommend to start from the shorter time (minutes to days), and extend it once everything works as expected.

If all subdomains for particular domain work under HTTPS, we can also add the directive `includeSubDomains`:

```
Strict-Transport-Security: max-age=31536000; includeSubDomains
```

In such case, this header needs to be sent from the root domain, so even if the application runs from `www.example.com`, at least one asset (including the HSTS header) needs to be loaded from `example.com` (non-www) domain.

Interesting note, confirming the choice of `307` redirect header in the previous chapter is that Chrome's internal redirect used for HSTS-based redirects uses the same `307` HTTP response code:

```
HTTP 307
Non-Authoritative-Reason: HSTS
```

## Further actions

After all these measures are applied, we have a web application fully operating via HTTPS. However the following measures can also be considered:

### HSTS Preload

While HSTS works for the particular web browser instance, the new visitors of the web application can be attacked.
The `HSTS Preload` feature can be used to include the certain domain to the [HSTS Preload](https://hstspreload.org/) list.
This list is hardcoded in all major web browsers. To include the domain to the list the following needs to be done:

* Include the following HSTS header (note that the value of `max-age` is equal to 2 years):

```
Strict-Transport-Security: max-age=63072000; includeSubDomains; preload
```

* Submit the domain to the [HSTS Preload](https://hstspreload.org/) list.

As the side-effect, you need to be aware that there will be no easy way back from HTTPS :)

### Tuning CSP

Content Security Policy can ease migration to HTTPS, but its main purpose is to protect agains code injection attacks (i.e. XSS).
Although during the migration project we might whitelist the insecure origins like `unsafe-eval`, `unsafe-inline` and others, such CSP policy does not do what it's meant for. The is even a list of such [Useless CSP](https://uselesscsp.com/).

The assessment of the application, identification of threats and remediating them, potentially utilizing CSP as a tool is a good follow-up activity.

### Learning more about web application security

There are way more topics and techniques to ensure the web application security.

Learning them and planning for the implementation within the web application should be the further steps.

As a good start, Mozilla Infosec team has a [good overview](https://infosec.mozilla.org/guidelines/web_security) of them ranked according to the security benefit and implementation effort.
