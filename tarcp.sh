#!/bin/sh

tar cf - "$1" | (cd "${2}" ; tar xvf -)
