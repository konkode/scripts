#!/bin/sh

vidnum=$1
while [ $0 ] ; do
    if [ $vidnum -gt 0 ] 2>/dev/null ; then
        break
    else
        printf "Enter number in video playlist: "
        read vidnum
    fi
done

mpv --ytdl-raw-options="playlist-start=$vidnum" "$2"
