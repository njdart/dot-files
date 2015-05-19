#!/usr/bin/python3
# setup script for my dot files
#
# from http://github.com/njdart/dot-files

import os
import os.path



ERRORCOLOUR = "\033[91m"
WARNINGCOLOUR = '\033[93m'
NOCOLOUR = "\033[0m"

# this souldnt be run as root
if os.geteuid() == 0:
  exit("This should NOT be run as root!")

# a destination-source tuple of directories, with sources possibly containing multiple entries
#
# entries are described as:
# 
#  (destinationDirectory, [sources])
# where usesUserHome is boolean True/False
# and destination is a directory
configFiles = [
  ("/etc/X11/xorg.conf.d/", ["10-keyboard.conf"]),
  ("/etc/", ["mpd.conf"]),
  ("/etc/lightdm/", [
     "greeters",
     "lightdm.conf"
  ]),
  ("$HOME/bin/", ["backgrounds"]),
  ("$HOME/.config/awesome/", [
    "brilliant",
    "icons",
    "myWidgets.lua",
    "rc.lua"
  ]),
  ("$HOME/.config/sxhkd/", ["sxhkdrc"]),
  ("$HOME/.config/bspwm/", ["bspwmrc"]),
  ("$HOME/.ncmpcpp", [".ncmpcpp"]),
  ("$HOME/", [
    ".muttrc",
    ".vimrc",
    ".xbindkeysrc",
    ".Xdefaults",
    ".Xresources",
    ".xprofile",
    ".xscreensaver",
    ".xinitrc",
    ".zshrc"
  ]),
  ("$HOME/screenshots/", []), # this is only to satisfy the scrot alias in .zshrc
]

for destinationSourceTuple in configFiles:

  destination = os.path.expandvars(destinationSourceTuple[0])
  sources = destinationSourceTuple[1]

  print("Working on directory " + destination)

  try:

    #validate the directory, if it doesnt exist, create it and deal with any permission denied errors
    if not os.path.exists(destination):
      os.makedirs(destination)

    for source in sources:
      fullSourcePath = os.getcwd() + "/" + source
      sourceFileName = os.path.basename(fullSourcePath)
      fullDestinationPath = destination + sourceFileName
      givenWarning = False

      # print(fullSourcePath + " -> " + fullDestinationPath)

      if not os.path.exists(fullSourcePath):
        print(ERRORCOLOUR + " ERROR, source file " + fullSourcePath + " does not exist" + NOCOLOUR);
        continue;

      try:
        if os.path.islink(fullDestinationPath):
          print(WARNINGCOLOUR + "  => Link " + fullDestinationPath + " exists, linking to " + os.path.realpath(fullDestinationPath) + ", replacing" + NOCOLOUR);
          givenWarning = True
          os.unlink(fullDestinationPath)
        elif os.path.isfile(fullDestinationPath):
          print(ERRORCOLOUR + "  => File " + fullDestinationPath + " exists, ignoring" + NOCOLOUR);
          continue;

        if not givenWarning:
          print("  => Symlinking " + fullSourcePath + " to " + fullDestinationPath);
        os.symlink(fullSourcePath, fullDestinationPath);

      except OSError as e:
        if e.errno == 13:
          print(ERRORCOLOUR + "    => ERROR: Permission denied to symlink " + source + " to " + fullDestinationPath + NOCOLOUR)
        else:
          print(e)

  except OSError as e:
    # On linux, errno 13 seems to be invalid permissions (eg for )
    if e.errno == 13:
      print(ERRORCOLOUR + "  => ERROR: Permission denied to make directory " + destination + NOCOLOUR)
    else :
      print(e)

