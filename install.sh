#!/bin/bash
# Get the directory of the script
# Sourc http://stackoverflow.com/questions/59895/can-a-bash-script-tell-what-directory-its-stored-in
DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
for FULLNAME in $(find $DIR -maxdepth 1 ! -name ".git" ! -name "install.sh" ! -name "*.swp" ! -iwholename "$DIR" ! -name ".gitignore")
do
	FILENAME=$(basename $FULLNAME)
	if [ -h $HOME/$FILENAME ]
	then
		echo "Skipping $FILENAME, symlink exists"
		continue
	fi
	if [ -e $HOME/$FILENAME ]
	then
		echo "Backing up existing copy of $FILENAME to $FILENAME.backup"
		mv $HOME/$FILENAME $HOME/$FILENAME.backup
	fi
	echo "Linking $FILENAME"
	ln -s $FULLNAME $HOME/$FILENAME
done
