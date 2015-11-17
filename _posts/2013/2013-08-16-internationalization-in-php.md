---
layout: post
title: Internationalization in PHP
tags:
 - php
 - i18n
 - l10n
 - utf
 - unicode
 - icu
---

> This page was initially [written in Lithuanian][old-post]. The examples contain Lithuanian phrases.

One of the most actual problems that application developers have to solve is adopting application to different languages (internationalication, i18n) and multi-cultural preferences, i.e. number, date formats etc. (localication, l10n).

For example:

 - direct text translation, text sorting, special chars conversion to latin symbols (transliteration);
 - plural forms, i.e.: English has 2 plural forms (one apple, many apples) whereas Lithuanian has three (vienas obuolys, du obuoliai, daug obuolių);
 - dates, i.e. European: 2013-08-16; USA: 8/16/13
 - currency, i.e.: 10 Lt, $10
 - length (meters, feet), weight (kilogrammes, pounds), capacity (liters, gallons) and other standarts (metric/imperial);
 - text writing from left to write (LTR), right-to-left (RTL);
 - etc.

Internationalization problems are commonly solved using standart operating system tool - locales. I.e.:
{% highlight php %}
<?php
setlocale(LC_TIME, 'lt_LT.UTF-8');
echo strftime('%c'); // 2013 m. rugpjūčio 16 d. 11:50:29
setlocale(LC_TIME, 'en_US.UTF-8');
echo strftime('%c'); // Fri 16 Aug 2013 11:50:29 AM EEST
{% endhighlight %}

However, locales do not solve all problems. Also, they must be installed in the operating system.

Under Linux OS you can see installed locale list using `locale -a`.

The project that solves more problems, related to unicode (UTF) internationalization, is ICU (Internationalization Components for Unicode):  [http://site.icu-project.org/](http://site.icu-project.org/)

ICU library has to be installed in the OS in order to use ICU (in case of Debian/Ubuntu, it is called `libicu*`)

PHP library is called `intl`. You can install it from PECL repository or if you're using Ubuntu, as a package `php5-intl`.

## Transliteration

Converting non-latin symbols to latin ones is a common problem, i.e.: when it is needed to form a clean URL.

`Transliterator` class can be used to perform such conversion: 

{% highlight php %}
<?php
$id = "Any-Latin; NFD; [:Nonspacing Mark:] Remove; NFC; [:Punctuation:] Remove; Lower();";
$transliterator = Transliterator::create($id);
$string = "ąčįū!?_-&% ĄČĘĖĮŠŲŪŽ";
echo $transliterator->transliterate($string);
// aciu aceeisuuz
{% endhighlight %}

If it is needed to generate URL slug, we can convert spaces to hyphens using RegExp:

{% highlight php %}
<?php
echo preg_replace('/\s+/', '-', 'tekstas   tekstas2');
// tekstas-tekstas2
{% endhighlight %}

The argument passed to Transliterator::create() can be formed according the [ICU transformation guide](http://userguide.icu-project.org/transforms/general).

NFC and NFD are [unicode normalization and denormalization functions](http://en.wikipedia.org/wiki/Unicode_equivalence).

## Sorting

Let's assume we need to sort Lithuanian words: urvas, ūkas, Ukmergė, ugnis. The expected result is: urvas, ūkas, Ukmergė, ugnis.

Normally the PHP array is sorted like this:

{% highlight php %}
<?php
$arr = ['urvas', 'ūkas', 'Ukmergė', 'ugnis'];
sort($arr);
print_r($arr);
// Array ( [0] => Ukmergė [1] => ugnis [2] => urvas [3] => ūkas )
{% endhighlight %}

The result is incorrect due to wrong collation (the capital letter is sorted first, the u with macron is sorted the last).

It is possible to hint `sort()` to use system locale by passing `SORT_LOCALE_STRING` as second argument:
{% highlight php %}
<?php
setlocale(LC_ALL, 'lt_LT.UTF-8');
$arr = ['urvas', 'ūkas', 'Ukmergė', 'ugnis'];
sort($arr, SORT_LOCALE_STRING);
print_r($arr);
// Array ( [0] => ugnis [1] => ūkas [2] => Ukmergė [3] => urvas )
{% endhighlight %}

The result is correct, but it can have negative impact, because in this example the locale is set globally. Also, it must be installed in the operating system.

The other way is to use `Collator` class:
{% highlight php %}
<?php
$arr = ['urvas', 'ūkas', 'Ukmergė', 'ugnis'];
$collator = new Collator('lt_LT');
$collator->sort($arr);
print_r($arr);
// Array ( [0] => ugnis [1] => ūkas [2] => Ukmergė [3] => urvas )
{% endhighlight %}

## Number formats

The number and currency formats are different in different languages. `NumberFormatter` can be used to display them correctly:
{% highlight php %}
<?php
$ltNum = new NumberFormatter('lt_LT', NumberFormatter::CURRENCY);
echo $ltNum->formatCurrency(1234567890.25, 'LTL');
// 1,234,567,890.25 Lt
echo $ltNum->formatCurrency(1234567890.25, 'EUR');
// 1,234,567,890.25 €
echo $ltNum->formatCurrency(1234567890.25, 'USD');
// 1,234,567,890.25 US$
 
$enNum = new NumberFormatter('en_US', NumberFormatter::CURRENCY);
echo $enNum->formatCurrency(1234567890.25, 'LTL');
// LTL1,234,567,890.25
echo $enNum->formatCurrency(1234567890.25, 'EUR');
// €1,234,567,890.25
echo $enNum->formatCurrency(1234567890.25, 'USD');
// $1,234,567,890.25
{% endhighlight %}

As we see the currencies are displayed differently depending on locale.

 
NumberFormatter class can also convert numbers to text (spellout):
{% highlight php %}
<?php
$ltNum = new NumberFormatter('lt_lt', NumberFormatter::SPELLOUT);
echo $ltNum->format(1234567890.25);
// vienas milijardas du šimtai trisdešimt keturi milijonų penki šimtai šešiasdešimt septyni tūkstančiai aštuoni šimtai devyniasdešimt kablelis du penki

$enNum = new NumberFormatter('en_US', NumberFormatter::SPELLOUT);
echo $enNum->format(1234567890.25);
// one billion two hundred thirty-four million five hundred sixty-seven thousand eight hundred ninety point two five
{% endhighlight %}
 
## Text formatting

It is very important to ensure not only the correct text translation, but also, the format of dates, numbers and plural forms of the words.

`MessageFormatter` class is used to do it, i.e. to display dates correctly:
 
{% highlight php %}
<?php
$enDate = new MessageFormatter('en_US', 'Today {0,date,short}');
echo $enDate->format(array(time()));
// Today 8/16/13
$enDate = new MessageFormatter('en_US', 'Today {0,date,long}');
echo $enDate->format(array(time()));
// Today August 16, 2013

$ltDate = new MessageFormatter('lt_LT', 'Šiandien {0,date,short}');
echo $ltDate->format(array(time()));
// Šiandien 2013-08-16
$ltDate = new MessageFormatter('lt_LT', 'Šiandien {0,date,long}');
echo $ltDate->format(array(time()));
// Šiandien 2013 m. rugpjūtis 16 d.
{% endhighlight %}
 
The locale and text format is passed to the constructor.
The `format()` argument is the array of data that is used by formatter.

 `{0,date,short}` means that the first `format()` array item is used as the date in short format.
 
`MessageFormatter` is also useful when working with plural forms:
 
{% highlight php %}
<?php
{% raw %}
$x = new MessageFormatter('lt_LT', 'Parduodu {0, plural, one{{0,number} obuolį} few{{0,number} obuolius} other{{0,number} obuolių}} ir {1, plural, one{{1,number} bandelę}few{{1,number} bandeles}other{{1,number} bandelių}} už {2,number,currency}');
{% endraw %}
echo $x->format(array(15, 2, 15));
// Parduodu 15 obuolių ir 2 bandeles už 15.00 Lt
{% endhighlight %}

More information in text formatting: [http://userguide.icu-project.org/formatparse/messages](http://userguide.icu-project.org/formatparse/messages)
Full list of plural forms: [http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html](http://unicode.org/repos/cldr-tmp/trunk/diff/supplemental/language_plural_rules.html)

Please give a feedback on working with `intl` functions with PHP since the functions are not fully documented in the manual. Thanks in advance :)

[old-post]: http://old.lescinskas.lt/daugiakalbiskumas-php