---
layout: post
title: Installing Sphinx with Lithuanian stemmer
---
> This page was initially [written in Lithuanian](http://old.lescinskas.lt/sphinx-su-lietuvisku-stemmeriu-diegimas). The examples contain Lithuanian phrases.

![Sphinx]({{ "/assets/img/posts/2013/sphinx.png" | prepend:site.baseurl }})

[Sphinx](http://sphinxsearch.com/) is an open source text search engine.

Although one of the main features of Sphinx is speed, other valuable feature is ability to create text index with word endings being cut (stemmed).

It allows to search for the word without knowing exact word ending.

For instance, Lithuanian word `stalas` would be transformed to word `stal` and it would be possible to find it using other forms of the word: `stalą`, `stalo`, `stalų` etc. 

Normally Sphinx can be installed from repository, but since stemmer is not standart Sphinx feature, and `Snowball Libstemmer` library is used instead, it needs to be compiled separately.

Let's begin :)

We will need these programs (can be installed via repository):

 - `make`
 - `g++` or `gcc` compiler
 - `mysql-client`
 - `libmysqlclient-dev` (Debian/Ubuntu distribution) or `mysql-devel` in other distributions (RedHat/CentOS)
 
Download the Sphinx source from [http://sphinxsearch.com/downloads/](http://sphinxsearch.com/downloads/) (in this case - version `2.0.8`)

Download Libstemmer C version from my repo [https://github.com/plutzilla/sphinx-libstemmer](https://github.com/plutzilla/sphinx-libstemmer) (`git clone git@github.com:plutzilla/sphinx-libstemmer.git .`) and put it to `libstemmer_c` directory.

It is not necessary to compiler Libstemmer separately (it will be compiled together with Sphinx), but if we do so, the program `stemwords` will be created. It can ve used to check how stemmer works, i.e.:

{% highlight bash %}
./stemwords -l lt
stalas
stal
stalą
stal
{% endhighlight %}
 
Of course there are words that are stemmed inadequately:
{% highlight bash %}
./stemwords -l lt
šienas
š
{% endhighlight %}

Configure Sphinx:
{% highlight bash %}
./configure --with-mysql-includes=/usr/include/mysql --with-mysql-libs=/usr/lib/mysql --with-libstemmer
{% endhighlight %}

Normally Sphinx is installed to `/usr/local`. If you want to change installation path, you can provide `--prefix=/path/to/installation`

As always, compile with command `make`, install using command `make install`.

To use Sphinx from other libraries, we need to compile Sphinx Client library:

{% highlight bash %}
cd api/libsphinxclient
./configure
make install
{% endhighlight %}

To use Sphinx from PHP, we need to isntall Sphinx PECL library:
{% highlight bash %}
pecl install sphinx
{% endhighlight %}

To be able to use PECL (install packaged from PECL repository), the followings packages must be installed previously: `php-pecl` and `php5-dev`.

After we install Sphinx PECL library, we need to add sphinx extension to `php.ini` file (paste `extension=sphinx.so`) and reload PHP - if PHP runs as Apache module, restart Apache, if it run as FastCGI, restart FastCGI or FPM service.
 
To start Sphinx on system boot, we need to create an Init script - create file `/etc/init.d/search.d` with content:
{% highlight bash %}
#!/bin/bash

case "${1:-''}" in
'start')
/usr/local/bin/searchd
;;
'stop')
/usr/local/bin/searchd --stop
;;
'restart')
/usr/local/bin/searchd --stop && /usr/local/bin/searchd
;;
*)
echo "Usage: $SELF start|stop|restart"
exit 1
;;
esac
{% endhighlight %}

If we want to keep Sphinx configuration file in non-default (`/usr/local/sphinx/etc/sphinx.conf`) location, we need to pass the parameter `--config /path/to/sphinx.conf`.

Also, if we want to run Sphinx with non-root user, it is possible to run searchd using the following command (put it to init script):

{% highlight bash %}
su - <unix-vartotojas> -c "/usr/local/bin/searchd --config /path/to/sphinx.conf"
{% endhighlight %}

After creating init script, we need to give ti execution permission and update rc.d configuration:
 
{% highlight bash %}
sudo chmod +x /etc/init.d/searchd
sudo update-rc.d searchd defaults
{% endhighlight %}

To use lithuanian stemmer, we need to provide this information to Sphinx configuration file:
{% highlight ini %}
morphology = libstemmer_lt
{% endhighlight %}

It is also useful to convert lithuanian characters to latin ones (transliterate). To use it, provide this information to the index config:

{% highlight ini %}
charset_table     = 0..9, A..Z->a..z, _, a..z, \
    U+104->a, U+105->a, \
    U+10C->c, U+10D->c, \
    U+116->e, U+117->e, \
    U+119->e, U+11A->e, \
    U+12E->i, U+12F->i, \
    U+160->s, U+161->s, \
    U+16A->u, U+16B->u, \
    U+172->u, U+173->u, \
    U+17D->z, U+17E->z
{% endhighlight %}

I am not writing about how to use Sphinx, how to create indices and index text - you can find this information in [Sphinx documentation](http://sphinxsearch.com/docs/) or in manuals: `man search`, `man searchd`, `man indexer`.

Huge thanks for [lt stemmer](http://sourceforge.net/projects/ltstemmer/) initiative and for [Linas Valiukas](https://github.com/pypt).