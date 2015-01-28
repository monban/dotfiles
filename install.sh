#!/bin/bash
for i in $(find . -maxdepth 1 ! -name ".git" ! -name "install.sh" ! -name "*.swp" ! -name "." -printf '%f\n'); do
	if [ -h $HOME/$i ]
	then
		echo "Skipping $i, symlink exists"
		continue
	fi
	if [ -e $HOME/$i ]
	then
		echo "Backing up existing copy of $i to $i.backup"
		mv $HOME/$i $HOME/$i.backup
	fi
	echo "Linking $i"
	ln -s `pwd`/$i $HOME/$i
done
