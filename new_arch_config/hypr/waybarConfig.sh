#!/usr/bin/env bash

# Kill existing waybar instances
pkill waybar

# Fetch monitors sorted by screen area (width * height) ascending
# Smallest resolution display becomes SMALLSCREEN, largest becomes LARGESCREEN
MONITORS=$(hyprctl monitors -j | jq -r 'sort_by(.width * .height) | .[].name')

export SMALLSCREEN=$(echo "$MONITORS" | head -n 1)
export LARGESCREEN=$(echo "$MONITORS" | tail -n 1)

# Substitute $SMALLSCREEN and $LARGESCREEN into final config
envsubst < ~/.local/share/waybar/layouts/personal/personal.jsonc > ~/.local/share/waybar/layouts/personal/config.jsonc

# Launch Waybar
/usr/bin/waybar -c ~/.local/share/waybar/layouts/personal/config.jsonc
