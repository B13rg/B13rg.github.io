---
layout: post
title:	"My Tmux Setup"
category: [Programming]
---

Tmux is a "Terminal Multiplexer", meaning you can create and use multiple terminals in one window at the same time.
It can be extensively customized and there are tons of examples of configurations posted all over the place.

My configuration lives in my [configuration github repo](https://github.com/B13rg/configuration).
In the tmux folder, you'll find two config files names `tmux.conf` and `tmux.remote.conf`.
The regular configuration is for the local computer, while the remote conf is for servers you remote into and start a tmux session on (usually through ssh).
The remote session has a few less lines, and a different prefix.

## Copying and pasting with WSL

One issue I ran into with tmux was running it on WSL.
It can be difficult to setup each so you can easily copy and paste within tmux and externally.

Set WSL to use `Ctrl+Shift+C/V` as Copy/Paste in the options tab of wSL settings.
To select text within the terminal to copy externally, hold

To select text to copy into windows, you'll want to hold either `shift` or `alt+shift`.
Holding `shift` will select line by line of the WSL window.
I only use this mode when I have a single panel in view.
If there are multiple panels, it ignore the boundaries.

![Selecting holding `shift`](/images/tmux/lineSelect.PNG){:width="700px"}

If you have multiple panels open, `alt+shift` will select a rectangle instead of line by line.
Once the text you want is selected, press `enter` to add it to your windows clipboard.
If you select text accidentally, press `escape` before trying to select again or else it will select from the original selection start to where you click.

![Selecting holding `alt+shift`](/images/tmux/squareSelect.PNG)

To copy text to the tmux clipboard, you'll simply select the text with the mouse without holding any keys down.
You can view the list of things you've copied by pressing `prefix+=`.
Then you can select which thing to insert at the cursor.

![Selecting text for tmux](/images/tmux/tmuxSelect.PNG)

## Commands

Quick list:

* Prefix is `alt+z`
* `prefix+R`: Reload configuration
* `prefix+r`: Redraw window
* `shift+arrow`: Switch windows
* `prefix+S`: Open new window from session template
* `alt+arrow`: Switch panes
* `prefix+z`: Zoom in current pane
* `prefix+-`: Horizontal split current pane
* `prefix+|`: Vertically split current pane
* `prefix+=`: Open tmux clipboard

---

These commands are all set in the `.tmux.conf` file present in my `$HOME` directory.

When making changes and customizing tmux, it is useful to be able to easily reload the configuration when you make changes.
To do this, I use the bind `bind R source-file ~/.tmux.conf`.

The first command I reset was the prefix key.
By default, it is set to `alt+b`, which is quite a stretch to reach.
I set my local tmux prefix to `alt+z` and the remote to `alt+x`.
This allows me to differentiate between the tmux session running locally or the tmux session nested within an ssh session on another server.
Additionally, `alt+z` is much easier and quicker to hit that the default.
The configuration code:

```txt
set -g prefix M-z
unbind C-b
bind M-z send-prefix
```

One command I use often is zoom.
`prefix+z` takes the current pane and full screens it.
It's useful for when you want to take a closer look at some output that smooshes just the wrong way when sequestered in a pane.

Moving between panes and windows quickly is important.
The default configuration can be difficult to remember, and not intuitive.
To switch between panes, I use `alt+arrow`.
It's also set so there is no need to push the `alt+z` prefix key to switch.

```txt
# Use alt+arrows to switch between panes
bind -n M-Left select-pane -L
bind -n M-Right select-pane -R
bind -n M-Up select-pane -U
bind -n M-Down select-pane -D
```

To switch between windows, I use `shift+arrow`.

```
# Use shift+lft/right to switch between windows
bind -n S-Left  previous-window
bind -n S-Right next-window
```

To create additional panes, I modified the commands to use `-` and `|` to split horizontally and vertically.
Additionally, all pane creation is done with the right hand instead of different hands doing different splits.

```txt
bind | split-window -h
bind - split-window -v
```

Having pre-configured windows that have a custom setup can be useful.
Once you create the file configuring the session, you can place it in a directory and bind a host key to automatically open it.
In my case, I use `bind S source-file ~/.tmux/session1`, which opens a custom view in a new window.

### Other settings:

* `set -g base-index 1`: Starts window numbering from 1, because 0 is on the other side of the keyboard.
* `set -g mouse on`:This allows me to use the mouse to do things like resize windows, select text, and click between panels.
* `set -sg escape-time 0`: Stop having to wait to press esc twice when canceling things.
* `set -g history-limit 10000`: Scrolling remembers 10,000 lines.
* `setw -g mode-keys vi`: Set mode to vi instead of emacs.

## Resources

* [Tmux man page](http://man7.org/linux/man-pages/man1/tmux.1.html)
* [Cheatsheet](https://tmuxcheatsheet.com/)
* [Examples of other tmux.conf](https://gist.github.com/search?o=desc&q=tmux.conf&s=stars)