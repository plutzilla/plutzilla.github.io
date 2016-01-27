---
layout: post
title: Mixing charsets
---

Recently I've had a weird situation





### Chrome

https://ebankas.seb.lt/cgi-bin/vbint.sh/web.p response
{% highlight html %}
HTTP/1.1 200 OK
Date: Fri, 15 Jan 2016 07:34:44 GMT
Server: Apache
Pragma: no-cache
Cache-Control: no-cache
Expires: -1
X-Cnection: close
Content-Type: text/html; charset=windows-1257
Connection: close
X-UA-Compatible: IE=Edge,chrome=1
Content-Length: 805

<html><body onload="window.document.vorm.submit();">  <form name="vorm" method="POST" action="https://deklaravimas.vmi.lt/InternetAuth.aspx">    <input type="hidden" name="SRC" value="70440">    <input type="hidden" name="TIME" value="2016.01.15 09:34:44">    <input type="hidden" name="PERSON_CODE" value="**HIDDEN**">    <input type="hidden" name="PERSON_FNAME" value="Leðèinskas"/>    <input type="hidden" name="PERSON_LNAME" value="Paulius"/>    <input type="hidden" name="SIGNATURE" value="TNwHpH3QNTbdYj2TKsejQKgyu26LIQhR5NKQoV5OtnWSQ1vNXYbE3rx+/3g0QygxXrUJ10ErwRfgPCmUQb+iUfjd/yhLoAN9S0wftPuk4KNdTGMRG6y0wvB4vnaIuESXvzNDIBkoeytJCentuvt1+yijfF+JKwxgvYoXHYXOjHA=">    <input type="hidden" name="TYPE" value="BANK-01">  </form></body></html>
{% endhighlight %}

https://deklaravimas.vmi.lt/InternetAuth.aspx response
{% highlight html %}
HTTP/1.0 200 OK
Server: BigIP
Connection: close
Content-Length: 796

<HTML><HEAD><script type=text/javascript language=javascript>  function s(){ document.f.submit(); } </script></HEAD><BODY onload=s(); >  <FORM name=f action='https://www.vmi.lt/sso/internetauth' method=post><INPUT type=hidden name='SRC' value='70440'><INPUT type=hidden name='TIME' value='2016.01.15 09:34:44'><INPUT type=hidden name='PERSON_CODE' value='**HIDDEN**'><INPUT type=hidden name='PERSON_FNAME' value='Leðèinskas'><INPUT type=hidden name='PERSON_LNAME' value='Paulius'><INPUT type=hidden name='SIGNATURE' value='TNwHpH3QNTbdYj2TKsejQKgyu26LIQhR5NKQoV5OtnWSQ1vNXYbE3rx+/3g0QygxXrUJ10ErwRfgPCmUQb+iUfjd/yhLoAN9S0wftPuk4KNdTGMRG6y0wvB4vnaIuESXvzNDIBkoeytJCentuvt1+yijfF+JKwxgvYoXHYXOjHA='><INPUT type=hidden name='TYPE' value='BANK-01'><INPUT type=submit value=Send></FORM></BODY></HTML>
{% endhighlight %}

As the response does not have a defined character encoding (neither in HTTP response headers, nor as the HTML meta tag), the Chrome browser treats the response as the default character set - in this situation **UTF-8**.

Since the surname characters `š` and `č` from the form field (PERSON_NAME) are not recognized as the proper UTF-8 characters, they are replaced by Unicode [replacement character](http://www.fileformat.info/info/unicode/char/0fffd/index.htm) (`U+FFFD`). When these characters are encoded back to the UTF-8, their representation becomes: `0xEF 0xBF 0xBD`.

Request to https://www.vmi.lt/sso/internetauth
{% highlight yaml %}
POST /sso/internetauth HTTP/1.1
Host: www.vmi.lt
Connection: close
Content-Length: 333
Cache-Control: max-age=0
Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8
Origin: https://deklaravimas.vmi.lt
Upgrade-Insecure-Requests: 1
User-Agent: Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/47.0.2526.106 Safari/537.36
Content-Type: application/x-www-form-urlencoded
Referer: https://deklaravimas.vmi.lt/InternetAuth.aspx
Accept-Encoding: gzip, deflate
Accept-Language: en-US,en;q=0.8,lt;q=0.6
Cookie: JSESSIONID=4743BDEAFA7A95F704C47C4EC2451AFA; ASP.NET_SessionId_For_ESKIS_EP=e55j2cxr4qovq03ug1aasfp5; BIGipServer~ESKIS~eskis-ext-ssp-https=116854956.47873.0000; BIGipServer~ESKIS~eskis-ext-p2-vip-https=250941612.47873.0000; BIGipServer~ESKIS~eskis-ext-p1-vip-https=234164396.47873.0000; JSESSIONID=A65217F77A4AEC379E06BB9F40D86010; BIGipServer~ESKIS~eskis-ext-p1-vip-http=234164396.20480.0000; __utma=22184892.1996620081.1452842668.1452842668.1452842668.1; __utmb=22184892.1.10.1452842668; __utmc=22184892; __utmz=22184892.1452842668.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none); AccessibilityMode=False

SRC=70440&TIME=2016.01.15+09%3A34%3A44&PERSON_CODE=**HIDDEN**&PERSON_FNAME=Le%EF%BF%BD%EF%BF%BDinskas&PERSON_LNAME=Paulius&SIGNATURE=TNwHpH3QNTbdYj2TKsejQKgyu26LIQhR5NKQoV5OtnWSQ1vNXYbE3rx%2B%2F3g0QygxXrUJ10ErwRfgPCmUQb%2BiUfjd%2FyhLoAN9S0wftPuk4KNdTGMRG6y0wvB4vnaIuESXvzNDIBkoeytJCentuvt1%2ByijfF%2BJKwxgvYoXHYXOjHA%3D&TYPE=BANK-01
{% endhighlight %}

You can see that `0xEF 0xBF 0xBD` (URL-encoded value: `%EF%BF%BD`) is posted as the HTML form value. As it differs from the original value, the signature, obviously, becomes wrong and further workflow is rejected.

#### How to make it work

Browser must treat the character set of response from https://deklaravimas.vmi.lt/InternetAuth.aspx respectively to make a proper request to further to https://www.vmi.lt/sso/internetauth.

There are 2 ways to make it work - either configure the user agent (browser) or provide the information about the charset in HTTP response headers.

##### Client setup

Setting the default charset to **windows-1257** solves the issue on the clien side:

![Firefox charset settings]({{ "/assets/img/posts/2016/chrome-fonts.png" | prepend:site.baseurl }})

However it just fixes the consequence, but **NOT** the cause, therefore it is just a hack, but not a solution.

##### Server setup

I have used Burp to intercept and modify the traffic to validate my assumptions.

Adding the `Content-Type: text/html; charset=windows-1257` response header makes the browser interpret the data correctly and solves the issue:

{% highlight html %}
HTTP/1.0 200 OK
Server: BigIP
Content-Type: text/html; charset=windows-1257
Connection: close
Content-Length: 796

<HTML><HEAD><script type=text/javascript language=javascript>  function s(){ document.f.submit(); } </script></HEAD><BODY onload=s(); >  <FORM name=f action='https://www.vmi.lt/sso/internetauth' method=post><INPUT type=hidden name='SRC' value='70440'><INPUT type=hidden name='TIME' value='2016.01.15 17:14:01'><INPUT type=hidden name='PERSON_CODE' value='**HIDDEN**'><INPUT type=hidden name='PERSON_FNAME' value='Leðèinskas'><INPUT type=hidden name='PERSON_LNAME' value='Paulius'><INPUT type=hidden name='SIGNATURE' value='CenMIXDs3iLMM9vL+KGYMS3h75Y+H/cbGAoTuU9XeGfjslw124S9qp7W/30xx2dLZcXGIOhqd1ZV7pkdvI5b0AcJpr+yMT6dol81UqCVlo5QhHOh7iz1DhscXkkF26USaOU8E9jRHwZzx/oUIVcMbye7EzP4VPnWCNpnGT5PER4='><INPUT type=hidden name='TYPE' value='BANK-01'><INPUT type=submit value=Send></FORM></BODY></HTML>
{% endhighlight %}

Since this solution is client-agnostic and can be controlled by the asset (system) owner, this is the proper solution.

### Firefox

Under firefox everything works fine, however it is a bit weird for me, as Firefox is configured to use system locale, which is not Baltic:
![Firefox charset settings]({{ "/assets/img/posts/2016/firefox-fonts.png" | prepend:site.baseurl }})

This also validates the assumption, that relying on the user agent is a bad practice.

## Conclusion

Well, not much to summarize here - ALWAYS ensure that your web application includes the charset in the HTTP response headers. Especially if you don't use Unicode.

## Other insights

Neither SEB bank website, nor VMI website, who operate PII (personally identifyable information) do not ensure strict transport security (via [HSTS]({%post_url 2015/2015-12-01-transport-layer-security-hsts %}), CSP and HPKP). Therefore it *might* be possible to spoof the certificates and intercept network traffic to these systems, storing sensitive information.