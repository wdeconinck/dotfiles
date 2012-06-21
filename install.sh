#! /usr/bin/env bash

# Get the directory this script resides in
DOTFILES="$( cd "$( dirname "$0" )" && pwd)"
echo "Installing dotfiles from $DOTFILES into $HOME"

$DOTFILES/decrypt.sh $DOTFILES
$DOTFILES/symlink.sh $DOTFILES

echo "Done"