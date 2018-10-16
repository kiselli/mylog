#!/bin/bash
# mylog.sh
## Writes developers diary
# Install
## ln -s <script_path> /usr/local/bin/lg
# Usage
## lg - Write new entry in mylog
## lg -t - today, show today file
## lg -a - all, show all files
## lg -c - concat, concat all files

# Configure the script
conf=$(realpath "$HOME/.mylog")

if [ ! -f $conf ]; then
	echo "dir=$HOME/mylog" > "$conf"
fi

source "$conf"

date=`date +%Y-%m-%d`
file=$(realpath "$dir/$date.md")
time=`date +%H:%M:%S`

# Concat all files to one and show in less, good for search
function concatAll {
	cat $dir/*.md | less
}

# Open all files to allow pagination via :n and :p
function openAll {
	less $dir/*.md
}

# Open todays file only
function openToday {
	less "$file"
}

# Write a new entry, stop after Ctrl+D is hit
function newEntry {
	echo "Write your log and press Ctrl+D"

	input=$(</dev/stdin)

	if [ ! -f $file ]; then
		echo "# $date" > "$file"
	fi

	echo -e "## $time\n" >> "$file"

	# 's/^#/###/m' - Fügt Überschriften 2 weitere Ebenen hinzu, damit sie Struktur nie zu weit nach unten rückt
	echo -e "$input" | sed -e 's/^#/###/m' >> "$file"
}

usage="$(basename "$0") [-h] [-t] [-a] [-c] -- script to write developers log

where:
    -h  help, show this help text
    -t  today, show today file
    -a  all, show all files navigate with :n and :p 
    -c  concat, concat all files"

OPTIND=1 

while getopts "h?tac" opt; do
    case "$opt" in
    h|\?)
        echo "$usage"
        exit 0
        ;;
    t)  openToday
        exit 0
        ;;
    a)  openAll
        exit 0
        ;;
    c)	concatAll
		exit 0
		;;
    esac
done

shift $((OPTIND-1))

[ "${1:-}" = "--" ] && shift

newEntry