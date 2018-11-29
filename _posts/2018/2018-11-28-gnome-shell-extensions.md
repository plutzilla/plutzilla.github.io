---
title: Gnome Shell extensions for a productive Ubuntu environment
layout: post
---

After Ubuntu replaced the Unity environment with Gnome Shell in 17.10 version, the old Ubuntu-diehards had to adopt this new interface and workflow.

While Unity was slightly limiting environment, I appreciated its focus to the productivity, usability and window space optimization.
Luckily, Gnome Shell environment can be customized using Gnome Extensions, allowing to achieve the same or even better level of productivity.

## Pre-installed extensions on Ubuntu

Ubuntu comes with 2 pre-installed extensions:

### Ubuntu AppIndicators

This extension shows Ubuntu AppIndicators and Gnome tray items in the top panel, allowing easy access to the menu controls and visual indicator of the certain applications:

![App indicators](/assets/img/posts/2018/appindicators.png)

For non-ubuntu users the same extension can be installed from [(K)StatusNotifierItem/AppIndicator Support](https://extensions.gnome.org/extension/615/appindicator-support/).

The legacy tray icons can be "moved" to the top panel using the [Top Icons Plus extension](https://extensions.gnome.org/extension/1031/topicons/).


### Ubuntu Dock

Ubuntu comes with the application launcher known as **Dock**. It is slightly modified version of [Dash to Dock extension](https://extensions.gnome.org/extension/307/dash-to-dock/), which is very popular among non-Ubuntu users of Gnome Shell. Its alternative [Dock to Panel](https://extensions.gnome.org/extension/1160/dash-to-panel/) is another good choice, considering that it combines the launcher and the application tray into the single panel.

![Dash to panel](/assets/img/posts/2018/dash-to-panel.png)

## Useful extensions

Besides AppIndicators and Dock extensions there are [plenty extensions](https://extensions.gnome.org/) to improve the usability and productivity. Here's the list of my favorite extensions (in alphabetical order):

### Alt Tab Workspace

While it is convenient to organize the windows in the workspaces, the `Alt-tab` navigation through these windows can be difficult.

The [Alt Tab Workspace extension](https://extensions.gnome.org/extension/310/alt-tab-workspace/) cycles through the windows in the active workspace only.

### Clipboard Indicator

For those who use copy/paste a lot it is useful to have the ability to see the clipboard history and switch between the clipboard items.

This could be achieved using the [Clipboard indicator extension](https://extensions.gnome.org/extension/779/clipboard-indicator/):

![Clipboard indicator](/assets/img/posts/2018/clipboard-indicator.png)

### Display Button

I use my computer in different locations using various external monitors and media projectors. It is not convenient to navigate through the settings each time I want to change the display layout (mirrored or joined displays).

The [Display Button extension](https://extensions.gnome.org/extension/939/display-button/) allows accessing the Display Settings within a single click.

### Hide Activities Button

I am a big fan of screen space optimization - I want to see only relevant information, therefore the "Activities" button in the top panel seems wasteful.

The [Hide Activities Button extension](https://extensions.gnome.org/extension/1128/hide-activities-button/) hides this button. The Activities window can still be accessed using the "hot" top left corner or by clicking the `Super` key.

### No Title Bar

Another great extension that optimizes the screen space is [No Title Bar](https://extensions.gnome.org/extension/1267/no-title-bar/). It is a highly customizable extension, which allows removing the unneccessary title bar for maximized applications, replacing the application name with the window name etc.

While standard Gnome apps look good in any case, as they don't have separate title bar, this is not the case in other applications.

So, instead of

![Before No Title Bar](/assets/img/posts/2018/no-title-bar1.png)

this extension lets you see

![After No Title Bar](/assets/img/posts/2018/no-title-bar2.png)

### OpenWeather

Apparently, one of the most popular Gnome extension is [OpenWeather extension](https://extensions.gnome.org/extension/750/openweather/):

![After No Title Bar](/assets/img/posts/2018/openweather.png)


### Removable Drive Menu

The [Removable Drive Menu](https://extensions.gnome.org/extension/7/removable-drive-menu/) is an extension that provides quick access to the mounted drives or network shares and allows quick unmount:

![Removable Drive Menu](/assets/img/posts/2018/removable-drive-menu.png)

### Sound Input & Output Device Chooser

[Sound Input & Output Device Chooser extension](https://extensions.gnome.org/extension/906/sound-output-device-chooser/) is one of the most useful extensions, which allows to switch the sound input and output devices and their profiles:

![Sound Input & Output Device Chooser](/assets/img/posts/2018/sound-input-output.png)

### Suspend Button

By default Gnome Shell does not expose the "Suspend" button in the User Interface. As I find this feature missing, such button can be added using the [Suspend Button extension](https://extensions.gnome.org/extension/826/suspend-button/):

![Suspend Button](/assets/img/posts/2018/suspend-button.png)

### system-monitor

It is convenient to see the computer resource usage in the top panel. This can be achieved using the [system-monitor extension](https://extensions.gnome.org/extension/120/system-monitor/):

![system-monitor](/assets/img/posts/2018/system-monitor.png)

This extension is the Gnome Shell alternative to Unity's "Indicator multiload". It is highly customizable extension.

However, it depends on certain libraries, which need to be installed using command:

```
$ sudo apt install gir1.2-gtop-2.0 gir1.2-networkmanager-1.0  gir1.2-clutter-1.0
```

Also, I had troubles installing this extension from extensions.gnome.org, so I had to install it from the command shell:

```
$ sudo apt install gnome-shell-extension-system-monitor 
```

More information on this extension can be found in the [extension's Github page](https://github.com/paradoxxxzero/gnome-shell-system-monitor-applet).

## Other useful tips

There are some other ways to increase productivity by tweaking the Gnome Shell settings. This can be done using the Tweaks application. It can be installed using the command:

```
$ sudo apt install gnome-tweak-tool
```

### Moving window controls to the left

Back in 2010 when window controls (close, minimize, maximize) were moved to left, it seemed strange for me at first. However the reason behind this move is pretty clear - as most important information (i.e. text in the document) and controls (i.e. menu items) are displayed in the top left side, placing window controls in the left side reduces the shift on the visual focus.

Although the default window controls are now placed on the right side, I don't treat this as a right decision. Good at least, this can be changed quite easily using the aforementioned `Tweaks` application:

![Window controls](/assets/img/posts/2018/window-controls.png)

### Top menu tweaks

I also tweak some of the top menu configuration parameters:

 * Enable activity hot corner
 * Display week numbers in the calendar
 * Show battery percentage

![Top menu tweaks](/assets/img/posts/2018/top-menu-tweaks.png)

### Touchpad tweaks

Using a laptop touchpad a lot it makes sense to define how the secondary and middle clicks are treated: either by tapping with 2 or 3 fingers, or by clicking the certain touchpad area. Clicking the certain area seems to me more error-prone therefore I use the "Fingers" option:

![Touchpad tweaks](/assets/img/posts/2018/touchpad-tweaks.png)