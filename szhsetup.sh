cp ./zsh-theme-powerlevel10k/ /usr/share/zsh-theme-powerlevel10k/
cp ./usr/share/oh-my-zsh/ /usr/share/oh-my-zsh/

git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git /tmp/pokemon-colorscripts
/tmp/pokemon-colorscripts/rinstall.sh
rm -rf /tmp/pokemon-colorscripts

cp ./.zshrc "${HOME}"