#!/usr/bin/env bash

# Restores the shader after screenshot has been taken
restore_shader() {
    if [ -n "$shader" ]; then
        hyprshade on "$shader"
    fi
}

# Saves the current shader and turns it off
save_shader() {
    shader=$(hyprshade current)
    hyprshade off
    trap restore_shader EXIT
}

save_shader # Saving the current shader

if [ -z "$XDG_PICTURES_DIR" ]; then
    XDG_PICTURES_DIR="$HOME/Pictures"
fi

scrDir=$(dirname "$(realpath "$0")")
source "$scrDir/globalcontrol.sh"
swpy_dir="${confDir}/swappy"
save_dir="${2:-$XDG_PICTURES_DIR/Screenshots}"
save_file=$(date +'%y%m%d_%Hh%Mm%Ss_screenshot.png')
temp_screenshot="/tmp/screenshot.png"

mkdir -p "$save_dir"
mkdir -p "$swpy_dir"

# Set save_dir in swappy config without forcing low quality compression
cat <<EOF > "$swpy_dir/config"
[Default]
save_dir=$save_dir
save_filename_format=$save_file
EOF

print_error() {
    cat <<"EOF"
    ./screenshot.sh <action>
    ...valid actions are...
        p  : print all screens
        s  : snip current screen
        sf : snip current screen (frozen)
        m  : print focused monitor
EOF
}

# Pass -scale 1 to grimblast to force native output pixel scaling
case $1 in
p) # print all outputs
    grimblast --scale 1 copysave screen $temp_screenshot && restore_shader && swappy -f $temp_screenshot ;;
s) # drag to manually snip an area / click on a window to print it
    grimblast --scale 1 copysave area $temp_screenshot && restore_shader && swappy -f $temp_screenshot ;;
sf) # frozen screen, drag to manually snip an area / click on a window to print it
    grimblast --scale 1 --freeze copysave area $temp_screenshot && restore_shader && swappy -f $temp_screenshot ;;
m) # print focused monitor
    grimblast --scale 1 copysave output $temp_screenshot && restore_shader && swappy -f $temp_screenshot ;;
*) # invalid option
    print_error ;;
esac

rm -f "$temp_screenshot"

if [ -f "${save_dir}/${save_file}" ]; then
    notify-send -a "t1" -i "${save_dir}/${save_file}" "saved in ${save_dir}"
fi