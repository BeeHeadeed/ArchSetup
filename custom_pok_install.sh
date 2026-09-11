#!/bin/sh

INSTALL_DIR='~/pok'
BIN_DIR='~/pok-bin'
DIR_PATH='~/pokemon-colorscripts'

# A basic install script for pokemon-colorscripts

git clone https://gitlab.com/phoneybadger/pokemon-colorscripts.git $DIR_PATH
mkdir $BIN_DIR
chmod 777 -R ~/tmp/

export PATH="$BIN_DIR:$PATH"

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
ln -s $INSTALL_DIR/pokemon-colorscripts/pokemon-colorscripts.py $BIN_DIR/pokemon-colorscripts

