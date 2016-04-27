---
layout: post
title: Public Suffix list
---

I was always wondering, why domains from United Kingdom are registered under `.co.uk` domain. Why not just under `.uk`?

It is up to each of the top level domain (TLD; i.e.: `.uk`) registrars to decide whether to allow registration of second level domains (i.e. `example.com`) or to create other specific rules (i.e. `example.co.uk`).
Although `.co.uk` is one of the most known ones, there are more exotic ones, i.e. `.pvt.k12.wy.us` These are calles **public suffixes** (or earlier - **effective TLDs**).

Besides the logical mismatch of domain names, such situation also creates a technical issue - setting cookies to the whole domain instead of the local scope.

As stated in [RFC6265](https://tools.ietf.org/html/rfc6265#section-5.2.3), HTTP cookie can have an attribute `Domain`, telling under which domain the cookie is included in each request from the user agent (web browser) to the server.
I.e. setting a cookie from `foo.example.com` domain it is possible either to limit the cookie validity to the `foo.example.com` domain, or to the whole `.example.com` domain.
In regular scenario, when whole 2nd level domain is controlled by the same owner, it might be a legit activity, but since `foo.co.uk` and `bar.co.uk` can be controlled by totally different owners, this situation would allow to set the cookies for the whole `.co.uk` domain (as the TLD is the same -`.uk`).

The same situation might happen not only with TLDs, but with hosting providers as well. Especially with those who allow their customers to use a 3rd level domain (i.e. `example.herokuapp.com`).

The similar issues might occur with wildcard SSL certificates, i.e. issuing wildcard certificate for the whole public suffix. Validating/invalidating an SSL certificate of the whole public suffix seems to be also under consideration ([RFC6125 section 7.2](http://tools.ietf.org/html/rfc6125#section-7.2)).

Since there is no easy way to distinguish which part of the particular domain is a publix suffix (especially, considering 4th level domain scenarios), the publix suffix list has been created: [publicsuffix.org](https://publicsuffix.org). It is maintained by [Mozilla foundation](http://www.mozilla.org/) and is used by the most common web browsers. According to the [learn page](https://publicsuffix.org/learn/) at publixsuffix.org these are the main use cases of the list for the browsers: 

### Firefox

 * Restricting cookie setting
 * Restricting the setting of the document.domain property
 * Sorting in the download manager
 * Sorting in the cookie manager
 * Searching in history
 * Domain highlighting in the URL bar
 * In the future it may be used for, for example, restricting DOM Storage allowances on a per-domain basis.

### Chromium/Google Chrome (pre-processing, parser)

 * Restricting cookie setting
 * Determining whether entered text is a search or a website URL

### Opera

 * Restricting cookie setting
 * Restricting the setting of the document.domain property
 
### Internet Explorer

 * Restricting cookie setting
 * Domain highlighting in the URL bar
 * Zone determination
 * ActiveX opt-in list security restriction

More generic list of use cases can be found at [Mozilla.org](https://wiki.mozilla.org/Public_Suffix_List/Use_Cases).

The use of this list is also suggested in [RFC6265](https://tools.ietf.org/html/rfc6265#section-5.3), saying that "If feasible, user agents SHOULD use an up-to-date public suffix list".

As modern browsers are dependent on such single sources of truth (like this list, or [HSTS]({%post_url 2015-12-01-transport-layer-security-hsts %}) preload list) it becomes more clear why browser updates are such frequent, and it leverages the importance of using up-to-date browsers to ensure the proper workflow and security of the web.

## Links

 * [publicsuffix.org](https://publicsuffix.org/)
 * [Mozilla](https://wiki.mozilla.org/Public_Suffix_List)
 * [Wikipedia](https://en.wikipedia.org/wiki/Public_Suffix_List)