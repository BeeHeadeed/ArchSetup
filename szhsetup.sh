git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git ~/tmp/pokemon-colorscripts
mkdir ~/pok-bin
chmod 777 -R ~/tmp/
./custom_pok_install.sh
rm -rf ~/tmp/pokemon-colorscripts

apt-get eza

echo "tamere"
cp ./.zshrc "${HOME}"