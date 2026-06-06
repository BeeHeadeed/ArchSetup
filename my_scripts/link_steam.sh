#!/bin/bash

# --- CONFIGURATION ---
# Adjust this to exactly where your Windows partition is mounted
WIN_MOUNT="/mnt/windows"

# The specific path you identified
WIN_STEAMAPPS="$WIN_MOUNT/Program Files (x86)/Steam/steamapps"

# The standard Arch Linux Steam path
LINUX_STEAMAPPS="$HOME/.local/share/Steam/steamapps"

echo "🔗 Starting the Steam bridge..."

# 1. Validation
if [ ! -d "$WIN_STEAMAPPS" ]; then
    echo "❌ Error: Could not find Windows steamapps at: $WIN_STEAMAPPS"
    echo "Check if the drive is mounted at $WIN_MOUNT"
    exit 1
fi

# 2. Sync the Manifests (.acf files)
# These files tell Steam the game is "Installed" so it doesn't try to download them.
echo "📄 Linking app manifests..."
ln -sfn "$WIN_STEAMAPPS"/*.acf "$LINUX_STEAMAPPS/" 2>/dev/null

# 3. Link the 'common' folder (The actual game data)
echo "📦 Linking game data (common folder)..."
if [ -d "$LINUX_STEAMAPPS/common" ] && [ ! -L "$LINUX_STEAMAPPS/common" ]; then
    echo "System: Linux 'common' folder is a real directory. Moving to 'common.bak' to avoid overwrite."
    mv "$LINUX_STEAMAPPS/common" "$LINUX_STEAMAPPS/common.bak"
fi
ln -sfn "$WIN_STEAMAPPS/common" "$LINUX_STEAMAPPS/common"

# 4. Handle 'shadercache' and 'compatdata'
# NTFS is bad at handling the tiny files/special characters Proton creates.
# We keep these on your Linux drive (SSD) for much better performance.
echo "⚙️ Ensuring compatdata stays on Linux for stability..."
if [ -L "$WIN_STEAMAPPS/compatdata" ]; then
    rm "$WIN_STEAMAPPS/compatdata"
fi

echo "✅ Done! Restart Steam."
