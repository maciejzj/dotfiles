#!/bin/sh
# Note that currently this config uses only dotfiles that are defaultly
# stored in home dir, if in the future there are any that should be stored
# in .config folder this requires modification.

# Grab all dotfiles in this folder
dotfiles=`ls -a | egrep "^\.\w+" | egrep -v "git"`

# Link dotfiles to home dir
for file in $dotfiles; do
	ln -sf ${PWD}/${file} ~/${file}
done

# Dectect if system is Mac
case $OSTYPE in
darwin*)
	echo "MacOS system detected"

	# Install homebrew
	echo "\033[1m\033[34m==> Installing brew\033[0m"
	if ! [ -x "`command -v brew`" ]; then   
		/usr/bin/ruby -e "`curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install`"
	else
		echo "Brew installed already, skipping"
	fi
	
	# Install homebrew programs from brewfile
	echo "\033[1m\033[34m==> Installing brew formulas\033[0m"
	brew bundle --file=${PWD}/brewfile
	;;
linux-gnu)
	echo linux
	;;
*)
	echo "Did not detect compatible OS, config install abandoned"
	exit 1
esac

# Install Vundle vim plugin manager
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

