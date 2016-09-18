#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
LOCAL_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
DIR_BIN="$HOME/voxforge/bin" 
DIR_HTK="$DIR_BIN/htk" 
DIR_JULIUS="$DIR_BIN/julius-4.3.1" 
DIR_SCRIPTS="$LOCAL_DIR/scripts" 
DIR_TUTORIAL="$HOME/voxforge/tutorial" 
DIR_CLARA="$LOCAL_DIR/clara" 

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

createDir "$DIR_TUTORIAL"

copyFiles "$DIR_CLARA/clara.grammar" "$DIR_TUTORIAL"
copyFiles "$DIR_CLARA/clara.voca" "$DIR_TUTORIAL"
copyFiles "$DIR_CLARA/prompts.txt" "$DIR_TUTORIAL"
copyFiles "$DIR_CLARA/clara_lexicon" "$DIR_TUTORIAL"

copyFiles "$DIR_SCRIPTS/dict2phone.py" "$DIR_BIN"
copyFiles "$DIR_SCRIPTS/mono0.py" "$DIR_BIN"
copyFiles "$DIR_SCRIPTS/mkdfa.jl" "$DIR_BIN"
copyFiles "$DIR_SCRIPTS/prompts2wlist.jl" "$DIR_BIN"
