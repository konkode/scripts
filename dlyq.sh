#!/bin/sh

# SPDX-License-Identifier: GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
# SPDX-FileCopyrightText: 2021 "KonQuesting" <code@konquesting.com>

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
            printf "\033[1;31mCan't get permission to install to system-wide directory. Quitting.\033[m\n"
            exit 1
        fi
    fi

link="$(curl https://github.com/mikefarah/yq/releases/latest 2>/dev/null | grep -o '"http.*"')"
version="$(echo "$link" | grep -o 'v[0-9].*[0-9]')"

install() {
echo "Downloading from ${link}"
printf "Installing yq %s for linux_amd64 to /usr/local/bin/yq\n" "$version"
wget https://github.com/mikefarah/yq/releases/download/"${version}"/yq_linux_amd64.tar.gz -O - 2>/dev/null | tar xz &&
$asRoot "mv yq_linux_amd64 /usr/local/bin/yq" &&
echo "Done!"
}

install
