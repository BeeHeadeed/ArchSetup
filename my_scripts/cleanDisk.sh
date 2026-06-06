sudo pacman -S pacman-contrib;
sudo paccache -r;
sudo pacman -R $(pacman -Qtdq);
rm -rf ~/.cache/*;