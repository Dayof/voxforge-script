#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
LOCAL_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

DIR_SCRIPTS="$LOCAL_DIR/scripts" 
DIR_CLARA="$LOCAL_DIR/clara" 

cd "$DIR_CLARA"
python ../scripts/wav2mfcc.py

cd ..

chmod +x manage_files.sh
chmod +x grammar.sh

sudo ./manage_files.sh
sudo ./grammar.sh
