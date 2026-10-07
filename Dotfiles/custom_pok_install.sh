#!/bin/sh

INSTALL_DIR="${HOME}/pok"
DIR_PATH="${HOME}/tmp/pokemon-colorscripts"
DOTFILES_DIR="${HOME}/dotfiles/Dotfiles"

# A basic install script for pokemon-colorscripts

rm -rf $DIR_PATH
git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git $DIR_PATH
chmod 777 -R ${HOME}/tmp/


# deleting directory if it already exists
rm -rf "$INSTALL_DIR/pokemon-colorscripts" || return 1

# making the necessary folder structure
mkdir -p $INSTALL_DIR/pokemon-colorscripts || return 1

# moving all the files to appropriate locations
cp -rf $DIR_PATH/colorscripts $INSTALL_DIR/pokemon-colorscripts
cp $DIR_PATH/pokemon-colorscripts.py $INSTALL_DIR/pokemon-colorscripts
cp $DIR_PATH/pokemon.json $INSTALL_DIR/pokemon-colorscripts

# create symlink in usr/bin
cp ${DOTFILES_DIR}/pokemon-colorscripts.sh ${INSTALL_DIR}/pokemon-colorscripts/
ln -s ${INSTALL_DIR}/pokemon-colorscripts/pokemon-colorscripts.sh ${INSTALL_DIR}/pokemon-colorscripts/pokemon-colorscripts

export PATH="$INSTALL_DIR/pokemon-colorscripts:$PATH"