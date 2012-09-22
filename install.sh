#!/bin/bash

self=$(basename "$0")
git ls-files | grep -v "$self" | while read f
do
    dest="$HOME/.$f"
    if [ ! -f "$dest" ] || ! diff "$f" "$dest" > /dev/null
    then
	echo -e "Copying \0033[1m$f\0033[0m to \0033[1m$dest\0033[0m"
        cp "$f" "$dest" || break
    fi
done
