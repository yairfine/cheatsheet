#!/bin/bash

THIS_DIR=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)

# command line arguemnt processing
if [ $# -gt 1 ]; then
    echo "Usage: $0 [destination]"
    exit 1
elif [ $# -eq 1 ]; then
    # Check if the argument is a valid directory
    if [ ! -d "$1" ]; then
        echo "$1 is not a valid directory."
        exit 1
    else
        DEST=$1
    fi
else # default destintaion
    DEST="/usr/local/bin"
fi

# install cheatsheet.sh script as `cs` executable
install -v -C -m 755 $THIS_DIR/cheatsheet.sh $DEST/cs
