#!/bin/bash

WM_err="/home/nic/.wmHistory"

echo $@ >> $WM_err

case $1 in
  dwm)
    xbindkeys
    /home/nic/bin/dwmBackgrounds & &>> $WM_err
    wmname LG3D
    conky | while read -r; do xsetroot -name "$REPLY"; done &
    exec $1 &>> $WM_err
    ;;
  startxfce4)
    exec $1 # &>> $WM_err
    ;;
  bspwm)
    sxhkd & &> WM_err
    exec bspwm &> WM_err
    ;;
  *)
    exec $1 &>> $WM_err ## ||
    echo "Unknown WM, add to .xinitrc" >> $WM_err
    ;;
esac
