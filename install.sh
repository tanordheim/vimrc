#!/bin/sh

set -e
set -x

BASEDIR=$(pwd -P)

ln -sf $BASEDIR ~/.vim
ln -sf $BASEDIR/vimrc ~/.vimrc

(cd bundle/YouCompleteMe && ./install.py --clang-completer --cs-completer --go-completer --js-completer)
