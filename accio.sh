#!/usr/bin/bash

APPDIR="$HOME/.spider"
PREFIX="$APPDIR/sites"

if [ ! -d "$PREFIX" ]; then
	echo "error: $PREFIX not found."
	exit
fi

while read -a line -p ">>>"; do
	if [ ${#line[@]} -eq 0 ]; then
		continue
	fi

	case "${line[0]}" in
		"accio")
			if [ ${#line[@]} -eq 1 ]; then
				echo "error: no keywords given"
				continue
			fi

			regex=".*"

			for kw in "${line[@]:1}"; do
				regex="$regex(?<![[:alnum:]])$kw(?![[:alnum:]]).*"
			done
			
			find $PREFIX -type f -name links -execdir grep -iP "$regex" "{}" ";" \
				| awk '{print NR, $0}' \
				| column -t
			;;
		*)
			echo "error: unrecognized command"
			;;
	esac
done
