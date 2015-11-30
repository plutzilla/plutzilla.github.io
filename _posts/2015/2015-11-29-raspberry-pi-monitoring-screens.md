---
layout: post
title: RaspberryPi for monitoring screens
tags:
    - raspberry
    - raspbian
    - kiosk
---

<img src="{{ '/assets/img/posts/2015/monitoring-tv.jpg' | prepend:site.baseurl }}" alt="Monitoring TV screens" class="img-responsive img-rounded" />

Displaying dashboard screens on TV is a very common case, especially in IT companies. TVs in the offices display business dashboards or the status of the applications or infrastructure.
Although there are multiple options to do it, we are mostly using RaspberryPi 2 to display Kibana, Grafana, Zabbix or other screens.

RaspberryPi 1 is too weak to display Kibana screens properly, therefore we had tried otehr alternatives as well: Google Chromecast devices, which are easy to use, cheaper than Raspberries, were dropping connections periodically, so they were unsuitable for day-to-day use. Other options, like MiniPC's are really good, but they are much more expensive.

RaspberryPi 2 is much more powerful than its predecessor and can handle "heavier" dashboards. They are pretty reliable, yet quite cheap, therefore we stuck to these devices.

However it needs to be configured properly in order to satisfy the following needs:

 - Screen should be fully filled with the view
 - After booting, the predefined screen should be loaded automatically
 - The screen should not sleep after some period of time
 - The mouse cursor should not be visible in the screen
 - The menus and taskbar should not be visible
 - After unclean reboot (i.e. after power outage), there should be no browser warning about unclean shutdown
 - It should be possible to connect to the device remotely to reload or change the view

## You will need

 - RaspberryPi 2
 - 8GB microSD card (preferrably with microSD -> SD adapter)
 - (preferrably) RaspberryPi case
 - DC charger with 5V output of **2 Ampers** and with microUSB jack (very common nowadays, as it is used for charging smartphones and tablets).
 - USB keyboard for configuration. Mouse is not necessary 

<img src="{{ '/assets/img/posts/2015/raspberry-pi-black.jpg' | prepend:site.baseurl }}" alt="RaspberryPi" class="img-responsive img-rounded" />

## Download OS for the RaspberryPi

The RaspberryPi comes with no operating system and with no internal storage.
Therefore we need to [download the Operating system](https://www.raspberrypi.org/downloads/) and install it to the microSD card.
The officially supported OS is Debian-based Raspbian, although there are [3rd party OS images](https://www.raspberrypi.org/downloads/) available as well.

Although there is "easy" installation method "Noobs", we will download regular [Raspbian image](https://www.raspberrypi.org/downloads/raspbian/) and copy it to the SD card.

During this tutorial I was using Raspbian Wheezy. There might be some nuances with the newer versions of Raspbian. Please share your feedback if you are using Jessie or newer versions of Raspbian.

## Copy image to the SD card:

Burning SD card from image using Windows can be done with [Win32 disk imager](http://sourceforge.net/projects/win32diskimager/files/latest/download) application.

From Linux, `dd` utility is used. Firstly we need to unmount all partitions from the SD card (if they are mounted). Then we need to copy the image to the SD card using command:

{% highlight text %}
paulius@pcpaulesl1:~$ sudo dd if=/path/to/raspbian/image of=/dev/mmcblk0 bs=4M
{% endhighlight %}

The `dd` command parameters are the following:

 - `if` - input file (downloaded image)
 - `of` - output file (destination). **Important**: the path might depend on your hardware. It must be a path to the device, but not to the partition. I.e. NOT `/dev/mmcblk0p1` (partition), but `/dev/mmcblk0` (device).
 - `bs` - block size. If not provided, the default 512 bytes block size will be used for copying. Bigger block sizes will give better performance up to some level. Providing at least 4 kilobytes (`bs=4k`) will give optimal performance.
 
See also: [Raspbian installation guide](https://www.raspberrypi.org/documentation/installation/installing-images/README.md)

## Plugging-in

After the SD card is prepared, we just need to plug it in, connect power and Ethernet cables and plug HDMI cable to RaspberryPi and TV set. The RaspberryPi will boot to the command line.

## Configure Raspberry

Firstly, perform basic configuration actions by launching `raspi-config` utility as root user:

{% highlight text %}
paulius@pcpaulesl1:~$ sudo raspi-config
{% endhighlight %}

### Expanding filesystem to the SD card size

In order to use the full capacity of the SD card, we need to expand the filesystem:

![Expanding Raspbian filesystem]({{ "/assets/img/posts/2015/raspberry-config-1.png" | prepend: site.baseurl}})

### Booting to the GUI instead of command line

![Booting Raspbian to GUI]({{ "/assets/img/posts/2015/raspberry-config-2.png" | prepend: site.baseurl}})

![Booting Raspbian to GUI]({{ "/assets/img/posts/2015/raspberry-config-3.png" | prepend: site.baseurl}})

### Disabling overscan

In order to fill the TV screen fully with the view, we might need to disable Overscan:

![Booting Raspbian to GUI]({{ "/assets/img/posts/2015/raspberry-config-4.png" | prepend: site.baseurl}})

![Booting Raspbian to GUI]({{ "/assets/img/posts/2015/raspberry-config-5.png" | prepend: site.baseurl}})

![Booting Raspbian to GUI]({{ "/assets/img/posts/2015/raspberry-config-6.png" | prepend: site.baseurl}})

### Connecting via SSH

All this and further configuration can be done by connecting to RaspberryPi from remote computer via SSH:

{% highlight text %}
paulius@pcpaulesl1:~$ ssh pi@<raspberry IP address>
{% endhighlight %}

The default user is `pi`, password is `raspberry`.

We just need to know which IP to connect to. We can obtain this information with `ifconfig` command (run from RaspberyPi command line).

### Updating system

Run the following commands to update the system:

{% highlight text %}
sudo apt-get update
sudo apt-get upgrade
{% endhighlight %}

## Installing applications

We will be using the following applications:

 - `chromium` web browser
 - `unclutter` to hide the mouse cursor
 - `xscreensaver` to disable screen from sleeping

We can install then from repository using the following commands:

{% highlight text %}
paulius@pcpaulesl1:~$ sudo apt-get install chromium-browser unclutter xscreensaver
{% endhighlight %}

### Configuring unclutter

We need to setup unclutter to run automatically by writing the following text to file `~/.config/autostart/unclutter.desktop`

{% highlight ini %}
[Desktop Entry]
Version=1.0
Type=Application
Name=unclutter
Exec=unclutter -idle 1 -root
Terminal=false
StartupNotify=false
{% endhighlight %}

### Configuring xscreensaver

To disable the screensaver (screen becoming blank when inactive) we need to create file `~/.xscreensaver` with the content:

{% highlight text %}
mode: off
{% endhighlight %}

### Configuring chromium

#### Running chromium

We will run chrome by executing the `~/run_chromium.sh` script. We just need to change the URL we want to be open.

Create `~/run_chromium.sh` with content:
{% highlight bash %}
#!/bin/bash
rm -rf ~/.chromium_temp_dir
chromium-browser --kiosk --incognito --disable-translate --user-data-dir=.chromium_temp_dir http://example.com
{% endhighlight %}

It uses the custom user directory in order to prevent unclean shutdown errors. `--incognito` flag should be enough, but if the user profile directory gets corrupted, this is the easiest way to bypass any errors.

`--kiosk` will run browser in "Kiosk" (full-screen with some other restrictions) mode.

`--disable-translate` will not suggest to translate the websites.

#### Restarting chromium

In case we need to restart the Chromium (i.e. if it gets stuck or we want to change the dashboard URL), we can use the `~/restart_chromium.sh` script.
It works well when being connected via SSH, so there is no need to plug keyboard or mouse to the RaspberryPi to do it.

Create `~/restart_chromium.sh` with content:

{% highlight bash %}
#/bin/sh

killall chromium
DISPLAY=:0 ~/run_chromium.sh > /dev/null 2>&1 &
{% endhighlight %}

#### Making chromium auto-run

Create `~/.config/autostart/chromium.desktop` with the content:

{% highlight ini %}
[Desktop Entry]
Version=1.0
Type=Application
Name=chromium-browser
Exec=~/run_chromium.sh
Terminal=false
StartupNotify=false
{% endhighlight %}


## Cloning SD card

After we configure the single SD card, we might need to clone it to run multiple instances of Chromium on multiple TVs. It can be done using the same `dd` command.

Create image from SD card: 

{% highlight text %}
paulius@pcpaulesl1:~$ sudo dd if=/dev/mmcblk0 of=~/sdcard.img bs=4M
{% endhighlight %}

Clone image to card:

{% highlight text %}
paulius@pcpaulesl1:~$ sudo dd if=~/sdcard.img of=/dev/mmcblk0 bs=4M
{% endhighlight %}

## Credits and further reading

Big thanks to [Julius Vitkauskas](https://twitter.com/jvitkauskas) for aggregating the best ideas.

You can also read blog posts from [alexba.in](http://alexba.in/blog/2013/01/07/use-your-raspberrypi-to-power-a-company-dashboard/) or [danpurdy.co.uk](https://www.danpurdy.co.uk/web-development/raspberry-pi-kiosk-screen-tutorial/).