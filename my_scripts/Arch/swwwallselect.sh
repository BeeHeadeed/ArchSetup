#!/usr/bin/env sh

#// set variables
scrDir="$(dirname "$(realpath "$0")")"
source "${scrDir}/globalcontrol.sh"
rofiConf="${confDir}/rofi/selector.rasi"

#// set rofi scaling
[[ "${rofiScale}" =~ ^[0-9]+$ ]] || rofiScale=10
r_scale="configuration {font: \"JetBrainsMono Nerd Font ${rofiScale}\";}"
elem_border=$(( hypr_border * 3 ))

#// scale for monitor
mon_x_res=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .width')
mon_scale=$(hyprctl -j monitors | jq '.[] | select(.focused==true) | .scale' | sed "s/\.//")
mon_x_res=$(( mon_x_res * 100 / mon_scale ))

#// generate config
elm_width=$(( (28 + 8 + 5) * rofiScale ))
max_avail=$(( mon_x_res - (4 * rofiScale) ))
col_count=$(( max_avail / elm_width ))
r_override="window{width:100%;} listview{columns:${col_count};spacing:5em;} element{border-radius:${elem_border}px;orientation:vertical;} element-icon{size:28em;border-radius:0em;} element-text{padding:1em;}"

#// launch rofi menu
currentWall="$(basename "$(readlink "${hydeThemeDir}/wall.set")")"
wallPathArray=("${hydeThemeDir}")
wallPathArray+=("${wallAddCustomPath[@]}")
get_hashmap "${wallPathArray[@]}"
rofiSel=$(parallel --link echo -en "\$(basename "{1}")"'\\x00icon\\x1f'"${thmbDir}"'/'"{2}"'.sqre\\n' ::: "${wallList[@]}" ::: "${wallHash[@]}" | rofi -dmenu -theme-str "${r_scale}" -theme-str "${r_override}" -config "${rofiConf}" -select "${currentWall}")

#// apply wallpaper
if [ ! -z "${rofiSel}" ] ; then
    for i in "${!wallPathArray[@]}" ; do
        setWall="$(find "${wallPathArray[i]}" -type f -name "${rofiSel}")"
        [ -z "${setWall}" ] || break
    done
    "${scrDir}/awwwallpaper.sh" -s "${setWall}"
    notify-send -a "t1" -i "${thmbDir}/$(set_hash "${setWall}").sqre" " ${rofiSel}"

    ### FORCE HIGH CONTRAST FOR VSCode ###
    if command -v convert >/dev/null 2>&1; then
        # Check if wallpaper has enough contrast
        # Generate a very high contrast palette for VSCode if the image is too monochrome
        satValue=$(convert "$setWall" -colorspace HSL -resize 1x1 txt:- | grep -oP '[(]\K[0-9]+,[0-9]+,[0-9]+' | cut -d',' -f2)

        echo "Wallpaper Saturation: $satValue"

        if [ "$satValue" -lt 50 ]; then
            # Aggressively force high-contrast colors (black, white, and red, etc.)
            echo "Low saturation detected. Forcing high contrast for VSCode..."
            
            # Set very distinct colors for VSCode theme
            # Forcefully inject a high-contrast palette with strong color differentiation
            wallbash --contrast 100 --saturation 100 --paletteAlgorithm vibrant --paletteCount 16

            # Explicit high contrast color palette
            wallbash --paletteColors "#000000" "#FFFFFF" "#FF0000" "#00FF00" "#0000FF" "#FFFF00" "#FF00FF" "#00FFFF" --contrast 100 --saturation 100

            notify-send "Wallbash: Aggressive High Contrast (Low saturation detected)"
        else
            # Default contrast and saturation for well-balanced wallpapers
            wallbash --contrast 30 --saturation 30 --paletteAlgorithm default --paletteCount 12
            notify-send "Wallbash: Normal Contrast Mode"
        fi
    else
        echo "ImageMagick (convert) not installed, skipping saturation check."
        # Default behavior for no contrast check
        wallbash --contrast 30 --saturation 30 --paletteAlgorithm default --paletteCount 12
        notify-send "Wallbash: Default Mode (No ImageMagick)"
    fi
fi