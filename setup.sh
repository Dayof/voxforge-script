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

enterDir "$HOME"
enterDir "voxforge"
enterDir "bin" 

echo "----------Setup HTK----------"

copyFiles "$LOCAL_DIR/htk" "$HOME/voxforge/bin"

install_dependency "GCC compilers" "gcc-3.4 g++-3.4 libx11-dev:i386 libx11-dev" || exit

#echo "-----Updating symbolink for gcc-3.4-----" 
#sudo update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-3.4 50
#sudo update-alternatives --install /usr/bin/g++ gcc /usr/bin/g++-3.4 50
#sudo ln -s gcc-3.4 gcc34
#sudo ln -s g++-3.4 g++34

echo "-----Configure HTK for 64-bit System-----" 
#linux32 "$DIR_HTK"/./configure CC=gcc34 --prefix="$DIR_HTK"
linux32 "$DIR_HTK"/./configure --prefix="$DIR_HTK" --disable-hslab

echo "-----Build the libraries and binaries of HTK-----" 
enterDir "$DIR_HTK" 
sudo make -j $nproc
sudo make install
if [ $? -eq 0 ]; then
    echo "-----Done installing HTK!-----"
else
	pwd
	echo "-----Error in Makefile of HTK, trying to fix-----"
	exit
	#enterDir "$LOCAL_DIR" 
	#rmFiles "$DIR_HTK/HLMTools/Makefile"
    	#copyFiles "$LOCAL_DIR/Makefile" "$DIR_HTK/HLMTools"
	#sudo make install
	#echo "-----Fixed error in Makefile of HTK-----"
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




