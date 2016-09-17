#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
LOCAL_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
DIR_BIN="$HOME/voxforge/bin" 
DIR_HTK="$DIR_BIN/htk" 
DIR_JULIUS="$DIR_BIN/julius-4.3.1" 

install_dependency() 
{
		echo "-----Installing $1-----"
		sudo apt-get -y install "$2"
		echo "-----Done installing $1!-----"
}

createDir()
{
	if [ ! -d "$1" ]; then
		mkdir "$1" || exit
		echo "-----Folder $1 created-----"
	else 
		echo "-----Folder $1 already exists-----"
	fi
}

enterDir()
{
	createDir "$1"  
	cd "$1" || exit
	echo "-----Enter folder $1-----"
}

copyFiles()
{
	cp -R "$1" "$2" || exit
	echo "-----Copy file $1 to folder $2-----"
}

rmFiles()
{
	sudo rm -rf "$1"|| exit
	echo "-----Removing $1-----"
}

echo "----------Setup VoxForge----------"

sudo apt-get -y update
sudo apt-get -y upgrade

enterDir "$HOME/voxforge"
enterDir "$DIR_BIN" 

echo "----------Setup HTK----------"

copyFiles "$LOCAL_DIR/htk" "$HOME/voxforge/bin"

install_dependency "GCC compilers" "gcc-3.4 g++-3.4 libx11-dev:i386 libx11-dev" || exit

echo "-----Configure HTK for 64-bit System-----" 
#enterDir "$DIR_HTK" 
linux32 ./configure --prefix="$DIR_HTK"

echo "-----Build the libraries and binaries of HTK-----" 
enterDir "$DIR_HTK" 
sudo make -j $nproc
sudo make install	
if [ $? -eq 0 ]; then
    echo "-----Done installing HTK!-----"	
else
	echo "-----Error in Makefile of HTK, try to fix-----"
	exit
fi

echo "----------Setup Julius----------"

enterDir "$LOCAL_DIR" 
copyFiles "$LOCAL_DIR/julius-4.3.1" "$HOME/voxforge/bin"
PATH="$DIR_HTK/bin:$DIR_JULIUS/bin:$PATH"
source ~/.bashrc

echo "----------Setup Julia----------"
install_dependency "Julia" "julia" || exit

echo "----------Setup Audacity----------"
install_dependency "Audacity" "audacity" || exit




