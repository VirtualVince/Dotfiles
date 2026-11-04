#!/usr/bin/env bash
# Symlink these dotfiles into place.
# Anything already at a target path is moved into ~/.dotfiles-backup/<timestamp>/
# first; nothing is deleted. Re-running is safe (existing correct links are skipped).
#
#   bash install.sh            install
#   bash install.sh --dry-run  only print what would happen
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

# repo path : target
LINKS=(
    "fish/config.fish:$HOME/.config/fish/config.fish"
    "hypr/hyprland.lua:$HOME/.config/hypr/hyprland.lua"
    "hypr/.luarc.json:$HOME/.config/hypr/.luarc.json"
    "hypr/hyprpaper.conf:$HOME/.config/hypr/hyprpaper.conf"
    "hypr/scripts:$HOME/.config/hypr/scripts"
    "rofi/config.rasi:$HOME/.config/rofi/config.rasi"
    "waybar/config:$HOME/.config/waybar/config"
    "waybar/style.css:$HOME/.config/waybar/style.css"
    "waybar/scripts:$HOME/.config/waybar/scripts"
    "autoclicker.conf:$HOME/.config/autoclicker.conf"
    "bin/autoclicker:$HOME/.local/bin/autoclicker"
    "bin/autoclickerd:$HOME/.local/bin/autoclickerd"
    "bin/screenshot.sh:$HOME/.screenshot.sh"
)

run() {
    if [ "$DRY" = 1 ]; then echo "    (dry-run) $*"; else "$@"; fi
}

for entry in "${LINKS[@]}"; do
    src="$DOTFILES/${entry%%:*}"
    dst="${entry#*:}"

    if [ "$(readlink "$dst" 2>/dev/null)" = "$src" ]; then
        echo "ok      $dst"
        continue
    fi

    if [ -e "$dst" ] || [ -L "$dst" ]; then
        saved="$BACKUP${dst#"$HOME"}"
        echo "backup  $dst -> $saved"
        run mkdir -p "$(dirname "$saved")"
        run mv "$dst" "$saved"
    fi

    echo "link    $dst -> $src"
    run mkdir -p "$(dirname "$dst")"
    run ln -s "$src" "$dst"
done

if [ ! -d "$HOME/.config/hypr/backgrounds" ]; then
    echo
    echo "note: wallpapers are not included. Put two images at"
    echo "      ~/.config/hypr/backgrounds/login-main.png and login-side.png,"
    echo "      or edit ~/.config/hypr/hyprpaper.conf."
fi
