CONF_DIR=~/.config/
TMP_DIR=/tmp
REPO_DIR=~/depo

if [ ! -d "$REPO_DIR" ]; then
    mkdir $REPO_DIR
fi

auto_sudo() {
  # Usage: auto_sudo <command> [args...]
  if [[ $EUID -eq 0 ]]; then
    "$@"
  else
    sudo "$@"
  fi
}

auto_sudo pacman -S --needed git base-devel
git clone --depth 1 https://github.com/HyDE-Project/HyDE ~/HyDE
cd ~/HyDE/Scripts
./install.sh

# adding windows to grub
auto_sudo pacman -S os-prober

read "Path to windows main partition: "MAIN_WIN_PART_PATH
while [! -d $MAIN_WIN_PART_PATH]; then
    read "Invalid path: " MAIN_WIN_PART_PATH
fi;

WIN_PATH=/mnt/windowsEFI
if [! -d $WIN_PATH]; then
    mkdir $WIN_PATH
fi;

sudo mount $MAIN_WIN_PART_PATH $WIN_PATH;
cp -r $WIN_PATH/EFI/Microsoft /boot/EFI/
if [ ! -f /boot/EFI/Boot/bootmgfw.efi]; then
    echo "Windows boot file required but not found: /boot/EFI/bootmgfw.efi";
    exit;
fi;
