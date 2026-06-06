#!/bin/bash

WALLPAPER="$1"

# Check saturation
SATURATION=$(convert "$WALLPAPER" -colorspace HSL -resize 1x1 txt:- | grep -oP '[(]\K[0-9]+,[0-9]+,[0-9]+' | cut -d',' -f2)

if [ "$SATURATION" -lt 20 ]; then
  # Low saturation → Force Wallbash to go wild
  wallbash --contrast 5 --saturation 5 --paletteAlgorithm vibrant --paletteCount 10
else
  # Normal Wallbash
  wallbash
fi
