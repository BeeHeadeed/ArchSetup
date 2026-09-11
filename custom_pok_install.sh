#!/bin/sh

INSTALL_DIR="${HOME}/pok"
BIN_DIR="${HOME}/pok-bin"
DIR_PATH="${HOME}/tmp/pokemon-colorscripts"

# A basic install script for pokemon-colorscripts

rm -rf $BIN_DIR
rm -rf $DIR_PATH
git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git $DIR_PATH
mkdir $BIN_DIR
chmod 777 -R ${HOME}/tmp/

# export PATH="$BIN_DIR:$PATH"
export PATH="$BIN_DIR:$PATH"
export PATH="$INSTALL_DIR:$PATH"

# deleting directory if it already exists
rm -rf "$INSTALL_DIR/pokemon-colorscripts" || return 1

# making the necessary folder structure
mkdir -p $INSTALL_DIR/pokemon-colorscripts || return 1

# moving all the files to appropriate locations
cp -rf $DIR_PATH/colorscripts $INSTALL_DIR/pokemon-colorscripts
cp $DIR_PATH/pokemon-colorscripts.py $INSTALL_DIR/pokemon-colorscripts
cp $DIR_PATH/pokemon.json $INSTALL_DIR/pokemon-colorscripts

# create symlink in usr/bin
rm -rf "$BIN_DIR/pokemon-colorscripts" || return 1
cp ./pokemon-colorscripts.sh $INSTALL_DIR/pokemon-colorscripts/
ln -s $INSTALL_DIR/pokemon-colorscripts/pokemon-colorscripts.sh $BIN_DIR/pokemon-colorscripts
ln -s $INSTALL_DIR/pokemon-colorscripts/pokemon-colorscripts.sh $INSTALL_DIR/pokemon-colorscripts
