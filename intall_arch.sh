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


