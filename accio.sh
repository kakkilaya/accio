#!/usr/bin/bash

APPDIR="$HOME/.spider"
PREFIX="$APPDIR/sites"

if [ ! -d "$PREFIX" ]; then
	echo "error: $PREFIX not found."
	exit
fi

if [ $# -eq 0 ]; then
	echo "error: no keywords given."
	exit
fi

regex=".*"

for kw in "$@"; do
	regex="$regex(?<![[:alnum:]])$kw(?![[:alnum:]]).*"
done

find $PREFIX -type f -name links -execdir grep -iP "$regex" "{}" ";"
