#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
LOCAL_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
DIR_GRAMMAR="$LOCAL_DIR/scripts" 
DIR_CLARA="$LOCAL_DIR/clara" 

DIR_BIN="$HOME/voxforge/bin" 
DIR_HTK="$DIR_BIN/htk" 
DIR_JULIUS="$DIR_BIN/julius-4.3.1" 

DIR_TUTORIAL="$HOME/voxforge/tutorial" 
DIR_TRAIN="$HOME/voxforge/train" 
DIR_WAV="$HOME/voxforge/wav" 
DIR_HMM0="$DIR_TUTORIAL/hmm0" 
DIR_HMM3="$DIR_TUTORIAL/hmm3" 
DIR_HMM4="$DIR_TUTORIAL/hmm4" 

enterDir()
{ 
	cd "$1" || exit
	echo "-----Enter folder $1-----"
}

enterDir "$DIR_TUTORIAL"
echo "----------Generating dict files----------"
julia ../bin/mkdfa.jl clara
echo "----------Done dict----------"

echo "----------Generating word lists from prompt file----------"
julia ../bin/prompts2wlist.jl prompts.txt wlist
echo "----------Done word lists----------"

echo "----------Generating monophones 0 and 1----------"
python ../bin/dict2phone.py 
echo "----------Done monophones 0 and 1----------"

echo "----------Generating MLF (Master Label File) from prompt file----------"
julia ../bin/prompts2mlf.jl prompts.txt words.mlf
echo "----------Done MLF----------"

echo "----------Generating Word Level Transcriptions to Phone Level Transcriptions----------"
HLEd -A -D -T 1 -l '*' -d dict -i phones0.mlf mkphones0.led words.mlf 
HLEd -A -D -T 1 -l '*' -d dict -i phones1.mlf mkphones1.led words.mlf 
echo "----------Done HLed----------"

echo "----------Generating MFCC files from WAV----------"
HCopy -A -D -T 1 -C wav_config -S codetrain.scp 
echo "----------Done MFCC----------"

echo "----------Generating new version of prototype model----------"
HCompV -A -D -T 1 -C config -f 0.01 -m -S train.scp -M hmm0 proto
echo "----------Done new proto----------"

echo "----------Generating hmmdefs----------"
cp "monophones0" "$DIR_HMM0"
mv "$DIR_HMM0/monophones0" "$DIR_HMM0/hmmdefs"
enterDir "$DIR_HMM0"
python ../../bin/formatHmmdefs.py
echo "----------Done hmmdefs----------"

echo "----------Generating macros----------"
python ../../bin/macros.py
echo "----------Done macros----------"

echo "----------Re-estimate hmmdefs 3 times----------"
enterDir "$DIR_TUTORIAL"
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm0/macros -H hmm0/hmmdefs -M hmm1 monophones0
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm1/macros -H hmm1/hmmdefs -M hmm2 monophones0
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm2/macros -H hmm2/hmmdefs -M hmm3 monophones0
echo "----------Done re-estimate----------"

echo "----------Tie sp model----------"
cp -r "$DIR_HMM3"/* "$DIR_HMM4"
cp "$DIR_HMM0/sil_hmm.txt" "$DIR_HMM4"
enterDir "$DIR_HMM4"
python ../../bin/tieSil.py
enterDir "$DIR_TUTORIAL"
ls "$DIR_HMM4"
HHEd -A -D -T 1 -H hmm4/macros -H hmm4/hmmdefs -M hmm5 sil.hed monophones1
HERest -A -D -T 1 -C config  -I phones1.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm5/macros -H  hmm5/hmmdefs -M hmm6 monophones1
HERest -A -D -T 1 -C config  -I phones1.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm6/macros -H hmm6/hmmdefs -M hmm7 monophones1
echo "----------Done tie----------"
