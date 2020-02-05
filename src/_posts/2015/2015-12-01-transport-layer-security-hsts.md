---
layout: post
title: Transport layer security - HSTS
---

Transport layer security (TLS) is a protocol to encrypt data being sent over the network. Despite some flaws of the protocol itself ([POODLE], [Heartbleed]), it ensures that data sent through the network is not being read or intercepted (changed) by third parties. It should also ensure the privacy of the user, but since it is known that NSA and other intelligence agencies can decrypt and eavesdrop the data, we should not rely on it that much. However, it is still very beneficial to protect the user data against malicious 3rd party activities.

Even more, knowing that SSL certificates are quite cheap nowadays, or even given [for free][startssl], and there are [initiatives][letsencrypt] to ensure and automate data encyption, TLS should be the goal for every website to implement.

Although the protocol itself encrypts the data, there are other standarts allowing developers to make use of the HTTPS features even more. These are HSTS, CSP, HPKP, referrer policy, secure cookie flag and others.

I will review HSTS in this blog post.

## HTTP Strict Transport Security (HSTS)

Even if the HTTPS is enabled on the website, in some cases the same content is served unencrypted via plain HTTP protocol (mixed security context). This can be done either intentionally (which is obviously, not the best idea), or there might be a system misconfiguration, but it can lead to the same negative result - sensitive data exposure via insecure channel, which can result in session hijacking and other threats related to insecure communication.

HSTS is a technique to force user agents (web browsers) to make requests to the particular hosts using HTTP over secure channel (TLS; SSL) only, thereby reducing the likelihood of eavesdropping and man-in-the-middle attacks. It is supported by [all major browsers][caniuse-hsts].

### Usage

Forcing user agents to use HTTPS is done by the HTTP response header `Strict-Transport-Security`, sent by the website. The values of the header can be the following:

* `max-age` - time in seconds for the browser to remember to use HTTPS only for this domain (in this example - 30 days).

```
Strict-Transport-Security: max-age=2592000
```

* `includeSubDomains` - user agent will use the same HSTS policy for all nested subdomains. It should be used with caution, as there might be different applications running under other subdomains, that might not be configured to work properly with TLS.

```
Strict-Transport-Security: max-age=2592000; includeSubDomains
```

* `preload` - will add domain to the [HSTS preload list][hsts-preload]. This list is maintained by Chromium and also used by Firefox, Safari, IE and Edge browsers. This list is hardcoded and shipped with the browser. It solves the situation, when the first client request is made using plain HTTP, and attacker intercepts the response and removes the HSTS header.

```
Strict-Transport-Security: max-age=2592000; includeSubDomains; preload
```

### Further reading

HSTS (together with its limitation, that I didn't cover) is explained very clearly in [Wikipedia][hsts-wikipedia], [OWASP][hsts-owasp] and [RFC6797]. Also, there is a great [OWASP TLS cheatsheet].

[hsts-wikipedia]: https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security
[hsts-owasp]: https://www.owasp.org/index.php/HTTP_Strict_Transport_Security
[hsts-preload]: https://hstspreload.appspot.com/
[RFC6797]: https://tools.ietf.org/html/rfc6797
[OWASP TLS cheatsheet]: https://www.owasp.org/index.php/Transport_Layer_Protection_Cheat_Sheet
[startssl]: https://www.startssl.com
[letsencrypt]: https://letsencrypt.org/
[POODLE]: https://en.wikipedia.org/wiki/POODLE
[Heartbleed]: https://en.wikipedia.org/wiki/Heartbleed
[caniuse-hsts]: http://caniuse.com/#feat=stricttransportsecurity
