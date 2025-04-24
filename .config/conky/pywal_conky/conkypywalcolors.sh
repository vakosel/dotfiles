#!/bin/sh

dir="$HOME/.config/conky/pywal_conky/"

head -n 8 ~/.cache/wal/colors | sed 's/^#//' | awk 'BEGIN{i=1} {printf "color%d %s\n", i, $0; i++}' >$dir/latestcolors

cat $dir/latestcolors $dir/conkyseed >$dir/conkyrc &

echo "latest colors updated in conkyrc" &
