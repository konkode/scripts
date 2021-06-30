#!/bin/sh

if [ -z "$2" ] ; then
    quality="best"
else
    case $2 in
        [7]|[7][2][0]* )
            quality="best[height<=720]"
            ;;
        [4]|[4][8][0]* )
            quality="best[height<=480]"
            ;;
        [3]|[3][6][0]* )
            quality="best[height<=360]"
            ;;
    esac
fi

mpv --ytdl-format="$quality" https://twitch.tv/"$1" > /dev/null 2>&1 &
