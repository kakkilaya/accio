#!/usr/bin/bash

APPDIR="$HOME/.spider"
PREFIX="$APPDIR/sites"

if [ ! -d "$PREFIX" ]; then
	echo "error: $PREFIX not found."
	exit
fi

while read -a line -p ">>>"; do
	case "${line[0]}" in
		"accio")
			regex=".*"

			for kw in "${line[@]:1}"; do
				regex="$regex(?<![[:alnum:]])$kw(?![[:alnum:]]).*"
			done
			
			find $PREFIX -type f -name links -execdir grep -iP "$regex" "{}" ";"
			;;
		*)
			echo "error: unrecognized command"
			;;
	esac
done
