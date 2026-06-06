#!/bin/zsh

# Check if the script is run with one argument
if [ "$#" -ne 1 ]; then
  echo "Usage: $0 <version>"
  exit 1
fi

# Get the file path and file name
version=$1

# Configuration file path
config_file="/opt/discord/resources/build_info.json"

# Update the version line in the configuration file
sudo sed -i "s|\"version\": \"[^\"]*\"|\"version\": \"$version\"|" "$config_file"

# Check if the sed command was successful
if [ $? -ne 0 ]; then
  echo "Failed to update the configuration file"
  exit 1
fi

echo "Version updated successfully to $version"
