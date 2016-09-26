#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
LOCAL_DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

DIR_SCRIPTS="$LOCAL_DIR/scripts" 
DIR_CLARA="$LOCAL_DIR/clara_minimal" 
DIR_VF="$HOME/voxforge"

sudo rm -rf "$DIR_VF"

chmod +x manage_files.sh
chmod +x grammar.sh

sudo ./manage_files.sh
sudo ./grammar.sh
