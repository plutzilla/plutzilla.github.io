---
layout: post
title: RaspberryPi for monitoring
---

Clone card to image:

{% highlight text %}
paulius@pcpaulesl1:~$ sudo dd if=/dev/mmcblk0 of=~/sdcard.img 
15564800+0 records in
15564800+0 records out
7969177600 bytes (8.0 GB) copied, 793.705 s, 10.0 MB/s
{% endhighlight %}

Clone image to card:

{% highlight text %}
paulius@pcpaulesl1:~$ sudo dd if=~/sdcard.img of=/dev/mmcblk0 bs=4k
1945600+0 records in
1945600+0 records out
7969177600 bytes (8.0 GB) copied, 868.54 s, 9.2 MB/s
{% endhighlight %}

> Note: If you do not specify block size (`bs` parameter), the default 512 bytes block size will be used, thus in mose cases it will take 2-3 times longer to clone the card than when using i.e. 4 kilobytes block size (`bs=4k`).

