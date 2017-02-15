---
layout: post
title: Firefox Flash plugin floods syslog on Ubuntu

---

Firefox Adobe Flash plugin floods `/var/log/syslog` with the messages like these:

{% highlight plaintext %}
Feb 15 22:25:52 pcpaulesl1 plugin-containe[3776]: IA__gtk_widget_get_visual: assertion 'GTK_IS_WIDGET (widget)' failed
Feb 15 22:25:52 pcpaulesl1 plugin-containe[3776]: IA__gdk_colormap_new: assertion 'GDK_IS_VISUAL (visual)' failed
Feb 15 22:25:52 pcpaulesl1 plugin-containe[3776]: IA__gdk_colormap_alloc_colors: assertion 'GDK_IS_COLORMAP (colormap)' failed
Feb 15 22:25:52 pcpaulesl1 plugin-containe[3776]: IA__gtk_widget_modify_bg: assertion 'GTK_IS_WIDGET (widget)' failed
{% endhighlight %}

This is inconvenient as the disk is filled with the irrelevant data, the disk IO is consumed, and syslog becomes inconvenient to read.

One of the possible solutions is to send such output to `/dev/null` instead of syslog. This can be done by sending the `STDERR` stream to `/dev/null`.

As usually Firefox is started from the dash, or via application menu, the most convenient way is to modify the `.desktop` launcher file so it was run with the proper parameters.

Usually `.desktop` files are stored in `/usr/share/applications`. The `firefox.desktop` file from this directory should be modified by changing the following line:

{% highlight ini %}
Exec=firefox %u
{% endhighlight %}

to such one:

{% highlight ini %}
Exec=bash -c 'firefox %u 2>/dev/null'
{% endhighlight %}

This modification would send all the error output to `/dev/null` keeping syslog clear.

Post a comment if you have any other options.