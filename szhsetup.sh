./custom_pok_install.sh
rm -rf ~/tmp/pokemon-colorscripts

cp ./utils.sh ~/
./install_eza.sh

cp ./.p10k.zsh "${HOME}"
cp ./.zshrc "${HOME}"