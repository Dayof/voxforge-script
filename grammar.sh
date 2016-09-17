#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
LOCAL_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
DIR_BIN="$HOME/voxforge/bin" 
DIR_HTK="$DIR_BIN/htk" 
DIR_JULIUS="$DIR_BIN/julius-4.3.1" 
DIR_GRAMMAR="$LOCAL_DIR/grammar" 
DIR_TUTORIAL="$HOME/voxforge/tutorial" 
DIR_CLARA="$LOCAL_DIR/clara" 

enterDir()
{ 
	cd "$1" || exit
	echo "-----Enter folder $1-----"
}

enterDir "$DIR_TUTORIAL"
julia ../bin/mkdfa.jl clara
