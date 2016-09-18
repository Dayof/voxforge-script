#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
LOCAL_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

DIR_SCRIPTS="$LOCAL_DIR/scripts" 
DIR_CLARA="$LOCAL_DIR/clara" 
DIR_SPEAKER_01="$DIR_CLARA/wav/speaker_01" 

DIR_BIN="$HOME/voxforge/bin" 
DIR_HTK="$DIR_BIN/htk" 
DIR_JULIUS="$DIR_BIN/julius-4.3.1" 

DIR_TUTORIAL="$HOME/voxforge/tutorial" 
DIR_TRAIN="$HOME/voxforge/train" 
DIR_WAV="$DIR_TRAIN/wav" 
DIR_MFCC="$DIR_TRAIN/mfcc" 
DIR_MFCC_01="$DIR_MFCC/speaker_01" 

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
createDir "$DIR_TRAIN"
createDir "$DIR_WAV"
createDir "$DIR_MFCC"
createDir "$DIR_MFCC_01"

copyFiles "$DIR_CLARA/clara.grammar" "$DIR_TUTORIAL"
copyFiles "$DIR_CLARA/clara.voca" "$DIR_TUTORIAL"
copyFiles "$DIR_CLARA/prompts.txt" "$DIR_TUTORIAL"
copyFiles "$DIR_CLARA/clara_lexicon" "$DIR_TUTORIAL"
copyFiles "$DIR_CLARA/codetrain.scp" "$DIR_TUTORIAL"

copyFiles "$DIR_SCRIPTS/dict2phone.py" "$DIR_BIN"
copyFiles "$DIR_SCRIPTS/mkdfa.jl" "$DIR_BIN"
copyFiles "$DIR_SCRIPTS/prompts2wlist.jl" "$DIR_BIN"
copyFiles "$DIR_SCRIPTS/prompts2mlf.jl" "$DIR_BIN"
copyFiles "$DIR_SCRIPTS/wav_config" "$DIR_TUTORIAL"

copyFiles "$DIR_SCRIPTS/mkphones0.led" "$DIR_TUTORIAL"
copyFiles "$DIR_SCRIPTS/mkphones1.led" "$DIR_TUTORIAL"

copyFiles "$DIR_SPEAKER_01" "$DIR_WAV"
