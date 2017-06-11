#!/usr/bin/bash

APPDIR="$HOME/.spider"
PREFIX="$APPDIR/sites"
DEST="$HOME/accio"

if [ ! -d "$PREFIX" ]; then
	echo "error: $PREFIX not found."
	exit
fi

results=""

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
			
			results=`find $PREFIX -type f -name links -execdir grep -iP "$regex" "{}" ";" \
				| awk '{print NR, $0}' \
				| column -t`

			echo "$results"
			;;
		"get")
			if [ -z "$results" ]; then
				echo "error: search is empty"
				continue
			fi

			if [ ${#line[@]} -eq 1 ]; then
				echo "error: no id given"
				continue
			fi

			id=${line[1]}

			if ! [[ $id =~ ^[0-9]+$ ]]; then
				echo "error: invalid id"
				continue
			fi

			url=`echo "$results" | awk 'NR=='$id' {print $2}'`

			if [ -z "$url" ]; then
				echo "error: id does not exist"
				continue
			fi

			if [[ $url =~ .*/$ ]]; then
				echo "error: $url is a directory"
				continue
			fi

			wget -q -P $DEST $url &
			echo "started downloading $url"
			;;
		*)
			echo "error: unrecognized command"
			;;
	esac
done
