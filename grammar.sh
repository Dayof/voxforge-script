#!/bin/bash

QTDE_WAV_FILES=26

SOURCE="${BASH_SOURCE[0]}"
LOCAL_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
DIR_GRAMMAR="$LOCAL_DIR/scripts" 
DIR_CLARA="$LOCAL_DIR/clara" 

DIR_VF="$HOME/voxforge"

DIR_BIN="$DIR_VF/bin" 
DIR_HTK="$DIR_BIN/htk" 
DIR_JULIUS="$DIR_BIN/julius-4.3.1" 

DIR_TUTORIAL="$DIR_VF/tutorial" 
DIR_TRAIN="$DIR_VF/train"
DIR_MANUAL="$DIR_VF/manual"  
DIR_WAV="$DIR_VF/wav" 

DIR_HMM0="$DIR_TUTORIAL/hmm0" 
DIR_HMM3="$DIR_TUTORIAL/hmm3" 
DIR_HMM4="$DIR_TUTORIAL/hmm4"
DIR_HMM9="$DIR_TUTORIAL/hmm9" 
DIR_HMM15="$DIR_TUTORIAL/hmm15" 

enterDir()
{ 
	cd "$1" || exit
	echo "-----Enter folder $1-----"
}

oHFuck()
{ 
	echo "-----ERRO ANTES DE TERMINAR O PROCESSO DE TREINAMENTO-----"
	exit
	
}

enterDir "$DIR_CLARA"
echo "----------Convert wav files to mfcc----------"
python ../scripts/wav2mfcc.py "$QTDE_WAV_FILES" || oHFuck
echo "----------Done mfcc----------"

enterDir "$DIR_TUTORIAL"
echo "----------Generating dict files----------"
julia ../bin/mkdfa.jl clara || oHFuck
echo "----------Done dict----------"

echo "----------Generating word lists from prompt file----------"
julia ../bin/prompts2wlist.jl prompts.txt wlist || oHFuck
echo "----------Done word lists----------"

echo "----------Generating monophones 0 and 1----------"
python ../bin/dict2phone.py || oHFuck
echo "----------Done monophones 0 and 1----------"

echo "----------Generating MLF (Master Label File) from prompt file----------"
julia ../bin/prompts2mlf.jl prompts.txt words.mlf || oHFuck
echo "----------Done MLF----------"

echo "----------Generating Word Level Transcriptions to Phone Level Transcriptions----------"
HLEd -A -D -T 1 -l '*' -d dict -i phones0.mlf mkphones0.led words.mlf || oHFuck
HLEd -A -D -T 1 -l '*' -d dict -i phones1.mlf mkphones1.led words.mlf || oHFuck
echo "----------Done HLed----------"

echo "----------Generating MFCC files from WAV----------"
HCopy -A -D -T 1 -C wav_config -S codetrain.scp || oHFuck
echo "----------Done MFCC----------"

echo "----------Generating new version of prototype model----------"
HCompV -A -D -T 1 -C config -f 0.01 -m -S train.scp -M hmm0 proto || oHFuck
echo "----------Done new proto----------"

echo "----------Generating hmmdefs----------"
cp "monophones0" "$DIR_HMM0" || oHFuck
mv "$DIR_HMM0/monophones0" "$DIR_HMM0/hmmdefs" || oHFuck
enterDir "$DIR_HMM0" 
python ../../bin/formatHmmdefs.py || oHFuck
echo "----------Done hmmdefs----------"

echo "----------Generating macros----------"
python ../../bin/macros.py || oHFuck
echo "----------Done macros----------"

echo "----------Re-estimate hmmdefs 3 times----------"
enterDir "$DIR_TUTORIAL"
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm0/macros -H hmm0/hmmdefs -M hmm1 monophones0 || oHFuck
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm1/macros -H hmm1/hmmdefs -M hmm2 monophones0 || oHFuck
HERest -A -D -T 1 -C config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm2/macros -H hmm2/hmmdefs -M hmm3 monophones0 || oHFuck
echo "----------Done re-estimate----------"

echo "----------Tie sp model----------"
cp -r "$DIR_HMM3"/* "$DIR_HMM4" || oHFuck
cp "$DIR_HMM0/sil_hmm.txt" "$DIR_HMM4" || oHFuck
enterDir "$DIR_HMM4"
python ../../bin/tieSil.py || oHFuck
enterDir "$DIR_TUTORIAL"
HHEd -A -D -T 1 -H hmm4/macros -H hmm4/hmmdefs -M hmm5 sil.hed monophones1 || oHFuck
HERest -A -D -T 1 -C config  -I phones1.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm5/macros -H  hmm5/hmmdefs -M hmm6 monophones1 || oHFuck
HERest -A -D -T 1 -C config  -I phones1.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm6/macros -H hmm6/hmmdefs -M hmm7 monophones1 || oHFuck
echo "----------Done tie----------"

echo "----------Realigning the Training Data----------"
HVite -A -D -T 1 -l '*' -o SWT -b silence -C config -H hmm7/macros -H hmm7/hmmdefs -i aligned.mlf -m -t 250.0 150.0 1000.0 -y lab -a -I words.mlf -S train.scp dict monophones1> HVite_log || oHFuck
HERest -A -D -T 1 -C config -I aligned.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm7/macros -H hmm7/hmmdefs -M hmm8 monophones1 || oHFuck
HERest -A -D -T 1 -C config -I aligned.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm8/macros -H hmm8/hmmdefs -M hmm9 monophones1 || oHFuck
echo "----------Done realigning----------"

echo "----------Making Triphones from Monophones----------"
HLEd -A -D -T 1 -n triphones1 -l '*' -i wintri.mlf mktri.led aligned.mlf || oHFuck
julia ../bin/mktrihed.jl monophones1 triphones1 mktri.hed || oHFuck
HHEd -A -D -T 1 -H hmm9/macros -H hmm9/hmmdefs -M hmm10 mktri.hed monophones1 || oHFuck 
HERest  -A -D -T 1 -C config -I wintri.mlf -t 250.0 150.0 3000.0 -S train.scp -H hmm10/macros -H hmm10/hmmdefs -M hmm11 triphones1 || oHFuck
HERest  -A -D -T 1 -C config -I wintri.mlf -t 250.0 150.0 3000.0 -s stats -S train.scp -H hmm11/macros -H hmm11/hmmdefs -M hmm12 triphones1 || oHFuck
HDMan -A -D -T 1 -b sp -n fulllist0 -g maketriphones.ded -l flog dict-tri dict || oHFuck
julia ../bin/fixfulllist.jl fulllist0 monophones0 fulllist || oHFuck
julia ../bin/mkclscript.jl monophones0 tree.hed || oHFuck
HHEd -A -D -T 1 -H hmm12/macros -H hmm12/hmmdefs -M hmm13 tree.hed triphones1 || oHFuck
HERest -A -D -T 1 -T 1 -C config -I wintri.mlf  -t 250.0 150.0 3000.0 -S train.scp -H hmm13/macros -H hmm13/hmmdefs -M hmm14 tiedlist || oHFuck
HERest -A -D -T 1 -T 1 -C config -I wintri.mlf  -t 250.0 150.0 3000.0 -S train.scp -H hmm14/macros -H hmm14/hmmdefs -M hmm15 tiedlist || oHFuck
echo "----------Done triphones----------"

echo "----------Config and run Julius----------"
#cp "$DIR_TUTORIAL/clara.dfa" "$DIR_MANUAL" || oHFuck
#cp "$DIR_TUTORIAL/clara.dict" "$DIR_MANUAL" || oHFuck
#cp "$DIR_TUTORIAL/tiedlist" "$DIR_MANUAL" || oHFuck
#cp "$DIR_HMM15/hmmdefs" "$DIR_MANUAL" || oHFuck
#enterDir "$DIR_MANUAL"
#julius -input mic -C clara.jconf || oHFuck
echo "----------Done julius----------"

echo "----------Test LM----------"
HParse clara.gram wdnet || oHFuck
HVite -A -D -T 1 -T 1 -C config -H hmm15/macros -H hmm15/hmmdefs -S train.scp -l '*' -i recout.mlf -w wdnet -p 0.0 -s 5.0 dict tiedlist || oHFuck
HResults -I words.mlf tiedlist recout.mlf
echo "----------Done test----------"


