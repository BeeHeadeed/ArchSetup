#!/bin/zsh

# Check if the script is run with one argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <file_path>"
  exit 1
fi

# Get the file path and file name
file_path=$1
file_name=$(basename "$file_path")

# Destination directory
dest_dir="/usr/share/sddm/themes/Corners/backgrounds/"

# Copy the file to the destination directory
sudo cp "$file_path" "$dest_dir"

# Check if the copy was successful
if [ $? -ne 0 ]; then
  echo "Failed to copy the file to $dest_dir"
  exit 1
fi

# Configuration file path
config_file="/usr/share/sddm/themes/Corners/theme.conf"

# Update the Background line in the configuration file
sudo sed -i "s|^Background=.*|Background=\"backgrounds/$file_name\"|" "$config_file"

# Check if the sed command was successful
if [ $? -ne 0 ]; then
  echo "Failed to update the configuration file"
  exit 1
fi

echo "Background updated successfully to $file_name"
