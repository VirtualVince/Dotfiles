# Dotfiles

Hyprland desktop with a warm, minimal dark theme: Hyprland, Waybar, Rofi, fish and a few helper scripts. Built and used on Arch Linux.

**Requires Hyprland 0.57 or newer.** 0.57 replaced the old `hyprland.conf` format with Lua (`hyprland.lua`). If you're on an older Hyprland, use the last Hyprlang version of this repo: `git checkout hyprlang-final`.

## What's in here

| Repo path | Installs to | What it is |
|---|---|---|
| `hypr/hyprland.lua` | `~/.config/hypr/` | Hyprland config: binds, monitors, theme, autostart |
| `hypr/hyprpaper.conf` | `~/.config/hypr/` | Wallpaper per monitor |
| `hypr/scripts/xwayland-primary.sh` | `~/.config/hypr/scripts/` | Marks the main monitor as XWayland primary, so Wine/Proton games open there |
| `hypr/.luarc.json` | `~/.config/hypr/` | Lets lua-language-server autocomplete the Hyprland API |
| `waybar/` | `~/.config/waybar/` | Bar config, style and status scripts (CPU, GPU, RAM, volume, mic, VPN, power menu) |
| `rofi/config.rasi` | `~/.config/rofi/` | App launcher theme |
| `fish/config.fish` | `~/.config/fish/` | Shell prompt, vi mode, colors, aliases |
| `bin/autoclicker`, `bin/autoclickerd` | `~/.local/bin/` | Side-mouse-button autoclicker. Turns itself off while a game is running |
| `autoclicker.conf` | `~/.config/` | Autoclicker settings (button, clicks per second, mode) |
| `bin/screenshot.sh` | `~/.screenshot.sh` | Region screenshot to `~/Pictures/Screenshots` plus clipboard |

## Install

```sh
git clone https://github.com/VirtualVince/Dotfiles.git ~/Dotfiles
cd ~/Dotfiles
bash install.sh --dry-run   # preview
bash install.sh
```

`install.sh` symlinks each file into place. Anything already at a target path is moved to `~/.dotfiles-backup/<timestamp>/` first, and nothing is deleted. Because they're symlinks, pulling the repo updates your config.

### Packages (Arch names)

Required:

```
hyprland hyprpaper waybar rofi kitty dunst fish thunar playerctl grim slurp
wl-clipboard libnotify wireplumber libpulse pavucontrol lm_sensors
xorg-xrandr python ttf-jetbrains-mono-nerd
```

Optional:
- `nvidia-utils`, for the GPU module in waybar
- `eza`, for a nicer `ls`
- `network-manager-applet`, for a Wi-Fi tray icon
- the apps bound to keys: `brave-bin`, `obsidian`, `obs-studio`, `steam`

The autoclicker creates a virtual mouse through `/dev/uinput`. On Arch, the `steam` package's udev rules already give the logged-in user access. Without them, add a udev rule with `TAG+="uaccess"` for `uinput`.

## Make it fit your machine

Some settings are specific to my hardware. Change these first:

1. **Monitors**: `hypr/hyprland.lua`, MONITORS section. Monitors are matched by description. Get yours with `hyprctl monitors`. A fallback rule (`preferred`, `auto`) covers any monitor that doesn't match, so the config works before you edit it.
2. **Workspace-to-monitor mapping**: same file. Workspaces 1–5 go to the main monitor and 6–10 to the side one.
3. **Waybar workspaces**: `waybar/config` → `persistent-workspaces` uses connector names (`HDMI-A-1`, `DP-1`).
4. **Wallpapers**: not included. Put images at `~/.config/hypr/backgrounds/login-main.png` and `login-side.png`, or edit `hypr/hyprpaper.conf` (it also uses connector names).
5. **NVIDIA**: the `hl.env(...)` NVIDIA lines at the top of `hyprland.lua`. Remove them on AMD or Intel GPUs.
6. **XWayland primary**: `hypr/scripts/xwayland-primary.sh` looks for an Acer monitor. Change the match to your main monitor, or ignore it if you don't game through Proton.

Check the config before logging in:

```sh
Hyprland --verify-config --config ~/.config/hypr/hyprland.lua   # prints "config ok"
```

## Keybinds

| Keys | Action |
|---|---|
| `SUPER + Return` | kitty |
| `SUPER + D` | rofi app launcher |
| `SUPER + Q` | close window |
| `SUPER + F` | fullscreen |
| `SUPER + V` | toggle floating |
| `SUPER + 1…0` | go to workspace 1–10 |
| `SUPER + SHIFT + 1…0` | move window to workspace 1–10 |
| `SUPER + SHIFT + S` | region screenshot |
| `SUPER + SHIFT + F` | thunar |
| `SUPER + SHIFT + K` | suspend |
| `SUPER + B / O / R / S / M` | brave / obsidian / obs / steam / pavucontrol |
| Media keys | play/pause, next, previous (work on the lock screen too) |
