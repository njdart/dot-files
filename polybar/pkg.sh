#!/bin/bash
#
# https://github.com/jaagr/polybar/wiki/User-contributed-modules

pac=$(checkupdates | wc -l)
aur=$(cower -u | wc -l)

check=$((pac + aur))

if [[ "$check" != 0 ]]; then
  echo "$pac %{F#0a81f5}%{F-} $aur"
fi
