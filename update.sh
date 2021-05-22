#!/bin/sh

# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
# SPDX-FileCopyrightText: 2021 "KonQuesting" <kon@konquesting.com>

user="$(id -u 2>/dev/null)"

exists() {
    command -v "$@" > /dev/null 2>&1
}

asRoot='sh -c'
    if [ "$user" != 0 ]; then
        if exists sudo; then
            asRoot='sudo -E sh -c'
        elif exists su; then
            asRoot='su -c'
        else
            printf "\033[1;31mCan't get permission to upgrade system files. Quitting.\033[m\n"
            exit 1
        fi
    fi

new="$($asRoot "apt update 2>/dev/null |grep -oE '.{0,20}can be upgraded'")"
found="$?"

if [ $found = 0 ] ; then
    apt list --upgradable
    printf "\033[1;35m$new\033[m\n"
    echo
    confirmed="no"
    while [ $confirmed = "no" ]
    do
        printf "\033[1;33mDownload and install these updates? [y/N/changes]: \033[m"
        read yn1
        case $yn1 in
            [Yy]|[Yy][Ee][Ss]*)
                confirmed="yes"
                $asRoot "apt full-upgrade"
                ;;
            [Cc][Hh][Aa][Nn][Gg][Ee]* )
                lookup=$(echo "$yn1" | sed 's/change.* //i')
                apt-get changelog $lookup
                continue
                ;;
            [Cc]* )
                lookup=$(echo "$yn1" | sed 's/c //i')
                apt-get changelog $lookup
                continue
                ;;
            *)
                exit
                ;;
        esac
    done
    if [ "$1" = "flatpak" ] || [ "$1" = "f" ] ; then
        echo
        printf "\033[1;33mGet Flatpak updates? [y/N]: \033[m"
        read yn2
        case $yn2 in
            [Yy]|[Yy][Ee][Ss]* )
                flatpak update
                exit
                ;;
            * )
                exit
                ;;
        esac
    fi
elif [ "$1" = "flatpak" ] || [ "$1" = "f" ] ; then
    flatpak update
elif [ -z "$1" ] ; then
    echo "Already up to date."
else
    echo "Invalid argument. Skipping '$@'."
    echo "Already up to date."
fi
