#!/bin/bash

logFile="/home/$USER/.xinitrc.log"

date >> $logFile
echo $@ >> $logFile

case $1 in
  dwm)
    xbindkeys
    /home/$USER/bin/backgrounds & &>> $logFile
    wmname LG3D
    conky | while read -r; do xsetroot -name "$REPLY"; done &
    exec $1 &>> $logFile
    ;;
  startxfce4)
    exec startxfce4  &>> $logFile
    ;;
  bspwm)
    sxhkd & &>> logFile
    urxvt &
    xbindkeys
    /home/$USER/bin/backgrounds & &>> $logFile
    wmname LG3D
    /usr/bin/xscreensaver -no-splash & #Screen savers!
    exec bspwm &>> logFile
    ;;
  awesome)
    xbindkeys
    exec awesome
    ;;
  *)
    exec $1 &>> $logFile
    echo "Unknown WM, add to .xinitrc" >> $logFile
    ;;
esac
