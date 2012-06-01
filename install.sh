#! /usr/bin/env bash

# Get the directory this script resides in
DOTFILES="$( cd "$( dirname "$0" )" && pwd)"
echo "Installing dotfiles from $DOTFILES into $HOME"

cd $HOME

ln -sf $DOTFILES/bash_profile         .bash_profile
ln -sf $DOTFILES/git-completion.bash  .git-completion.bash
ln -sf $DOTFILES/gitignore            .gitignore
ln -sf $DOTFILES/gitconfig            .gitconfig
ln -sf $DOTFILES/gitk                 .gitk
ln -sf $DOTFILES/inputrc              .inputrc
ln -sf $DOTFILES/pystartup.py         .pystartup.py

echo "Done"