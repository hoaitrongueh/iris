# IRIS shortcuts

Super means the Windows/logo key. These desktop bindings were checked against the running Hyprland session. H/J/K/L mean left/down/up/right.

## Launch and terminals

| Shortcut | Action |
|---|---|
| Super+Enter | New randomly scattered floating terminal |
| Super+Shift+Enter | New tiled development terminal |
| Super+Ctrl+Enter | Arrange casual floating terminals on the current workspace/monitor into a neat grid |
| Super+Space or Super+R | Application launcher |
| Super+W | Zen browser |
| Super+D | Graphical code editor |
| Super+E | Dolphin file manager |
| Super+Ctrl+P | Spotify, preserving --disable-gpu |
| Super+Q | Close focused window; Kitty closes without confirmation |
| Super+F1 | Open this shortcut sheet |

## Windows and layouts

| Shortcut | Action |
|---|---|
| Alt+Tab | Return to most recently focused window on this workspace |
| Alt+Shift+Tab | Reverse traversal of visible windows |
| Super+arrow keys | Focus adjacent window |
| Super+H/J/K/L | Focus left/down/up/right |
| Super+Shift+arrow keys | Move window in that direction |
| Super+Shift+H/J/K/L | Move window left/down/up/right |
| Super+Ctrl+arrow keys | Resize focused window in 40-pixel steps |
| Super+left mouse drag | Move floating window |
| Super+right mouse drag | Resize window |
| Super+V | Toggle focused window between floating and tiled |
| Super+Shift+V | Toggle tiled / centered floating presentation layout (65% of screen) |
| Super+F | Toggle fullscreen |
| Super+Ctrl+M | Use master tiling layout: main pane with secondary panes |
| Super+Ctrl+D | Use dwindle tiling layout: recursive splits |
| Super+Ctrl+J | Toggle split orientation in dwindle |
| Super+P | Toggle pseudotiling (advanced: retain a preferred size inside a tile) |

## Workspaces and scratchpad

| Shortcut | Action |
|---|---|
| Super+1…9 | Switch to workspace 1…9 |
| Super+0 | Switch to workspace 10 |
| Super+Shift+1…9 | Move focused window to workspace 1…9 |
| Super+Shift+0 | Move focused window to workspace 10 |
| Super+mouse wheel down/up | Next/previous existing workspace |
| Three-finger horizontal swipe | Switch workspace |
| Super+S | Show/hide the scratchpad; create its terminal if needed |
| Super+Ctrl+S | Move focused window into the scratch workspace |

The scratchpad is a separate workspace overlay. Super+S reveals windows moved there; Super+Ctrl+S is not a save command.

## Dashboard and shell

| Shortcut | Action |
|---|---|
| Super+G | Show/hide the IRIS dashboard |
| Super+Shift+G | Toggle optional dashboard clock |
| Super+Ctrl+G | Toggle optional project identity card |
| Super+A | Toggle Caelestia sidebar |
| Super+C or Super+Ctrl+V | Clipboard history picker |
| Super+Ctrl+L | Lock session |
| Super+M | Session/power menu |
| Super+Ctrl+F9 | Select monochrome marble wallpaper |
| Super+Ctrl+F10 | Select atmospheric architecture wallpaper |

The wallpaper keys select those older static wallpapers instead of the eerie moon scene. Optional dashboard panels live on the dashboard's special workspace; use Super+G to reveal it if hidden.

## Screenshots and hardware keys

| Shortcut | Action |
|---|---|
| Print Screen or Super+Shift+S | Select any region from a frozen image; save and copy |
| Ctrl+Print Screen | Save and copy the complete visible frame |
| Shift+Print Screen | Select a frozen region and open the annotation editor |
| Volume up/down keys | Adjust volume by 5%, capped at 100% |
| Speaker mute key | Toggle output mute |
| Microphone mute key | Toggle microphone mute |
| Brightness up/down keys | Adjust brightness |
| Media play/pause key | Toggle playback |
| Media next/previous keys | Next/previous track |

Screenshots are saved in `~/Pictures/Screenshots` and copied as PNG images. Print Screen also works while locked: it captures the visible lock UI without unlocking. While locked, Print Screen still lets you select an area inside the lock UI; Escape or right-click cancels. Ctrl+Print Screen captures the complete lock screen.

Press Escape to cancel region selection without replacing the clipboard or saving an image. Some laptop hardware keys require Fn, depending on the keyboard's Fn-lock setting.

## Inside Kitty / Bash

| Shortcut | Action |
|---|---|
| Ctrl+Shift+C | Copy selection |
| Ctrl+Shift+V | Paste clipboard |
| Ctrl+Shift+F | Open terminal scrollback viewer |
| Ctrl+Shift+F5 | Reload Kitty configuration |
| Ctrl+C | Interrupt the foreground command |
| Ctrl+D | End input; at an empty Bash prompt, exit the shell |
| Ctrl+L | Clear/redraw the terminal screen |
| Ctrl+R | Search Bash command history |
| Ctrl+A / Ctrl+E | Beginning/end of command line |
| Ctrl+U / Ctrl+K | Delete to beginning/end of command line |
| Tab | Complete command or path |

The first four are explicitly configured Kitty bindings. The remaining entries are standard Bash/Readline controls, not compositor shortcuts. Programs running inside the terminal can handle these keys differently.

## Independent GUI launch commands

Use `iris spotify-launcher`, `iris workstation-editor .`, `iris workstation-zen`, or `iris dolphin` when launching a GUI app from a terminal. For debugging, run the original application command directly to keep its output attached.

Application logs: `journalctl --user -b -u 'app-*-iris@*.service'`.

A practical work sequence: Super+D for the editor, Super+Shift+Enter for a tiled terminal, Super+W for research, then Alt+Tab to switch. Casual terminals use Super+Enter; Super+Ctrl+Enter tidies them whenever you want.

## Caelestia dashboard and right rail

The top-edge Caelestia dashboard contains Dashboard, Media and System tabs. Hover at the top edge to open it. The Dashboard tab includes the calendar, CPU/memory/storage status, application shortcuts and a real audio spectrum. The Media tab retains lyrics, seeking, shuffle, repeat and player selection. The spectrum sleeps when paused or closed.

Move the pointer to the middle of the right edge to reveal the application rail. Right-click the top Apps button to open Caelestia's dashboard. The bell and power buttons open notifications and session controls. The left bar and the additional persistent top bar are disabled.

Glassify is installed locally in `~/.config/spicetify/Themes/Glassify`. Its settings remain available from the Spotify profile menu. After a Spotify update, use `spicetify backup apply` to restore customization. IRIS initially selects a static background, smaller blur and all player controls; you can change these in Glassify Settings.
