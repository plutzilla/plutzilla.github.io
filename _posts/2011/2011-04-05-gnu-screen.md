---
layout: post
title: GNU screen
---
GNU screen is a virtual terminal multiplexer. It is possible to run multiple virtual terminals in the same console window, switch between them, split the window and place the terminals in it, execute the commands or run programs simultaneously. It is also possible to tun multiple `screen` instances.

![GNU screen]({{ "/assets/img/posts/2011/gnu-screen.png" | prepend: site.baseurl }})

It is possible to run the program and to connect to the same program from remote computer (using the same screen instance).

Normally, the program is terminated when the terminal, which the program was run from, is closed, or the connection is lost.

The screen, in which the program is run, remains active, and it is possible to resume to the program in the screen.

The use case of screen is very broad, especially when it is needed to run long-running processes in the remote server, and it is crucial to ensure that the program will not be terminated if the connection is lost. I.e. the BitTorrent clients can be left running in the remote server, and left for seeding (surely, legal) files.

The screen is run using the command:

`$ screen`

It is also possible to start "named" screen:

`$ screen -S <name>`

Full list of running screen instances:

`$ screen -ls`

Resuming to the screen:

`$ screen -r`

If there are multiple running screens, their list is returned:

{% highlight bash %}
There are screens on:
31296.pavadinimas	(04/05/2011 06:04:51 PM)	(Detached)
30781.pts-0.paulius	(04/05/2011 05:39:06 PM)	(Attached)
2 Sockets in /var/run/screen/S-paulius.
{% endhighlight %}

In this case it is needed to provide the instance name to resume to, i.e.:

`$ screen -r 31296.pavadinimas`

After logging to the screen, the screen management commands (exit, detach, split screen, manage windows...) are done by pressing the following key combination: `Ctrl+a` (further C-a), then releasing it, and pressing other key.

**Important note**: the letters are case SENSITIVE, i.e.: `C-a x` is not the same as `C-a X`.

## Commands

Detach (exiting without terminating screen): `C-a d`

Exit (terminating screen): `C-a \` (is is also possible to exit by closing windows with `Ctrl+d`)

Lock screen: `C-a x`

### Window management commands

Create new window: `C-a c`

Close existing window: `C-a k`

Switch to other window: `C-a <space>`

Switch to previous window: `C-a <backspace>`

Display window list to switch to: `C-a "`

Change window name: `C-a A`

### Region (split windows) management commands


Split active window horizontally: `C-a S`

Split active window vertically: `C-a |`

Switch to other region: `C-a <tab>`

Close active region: `C-a X`


After creating new region and moving to it, is is needed to create a new window (`C-a c`) or to switch to existing window (`C-a <space>` or choose from window list - `C-a "`).