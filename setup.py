#!/usr/bin/python3
# setup script for my dot files
#
# from http://github.com/njdart/dot-files

import os
import os.path
import glob
import socket
import sys
import pwd
import grp

ERRORCOLOUR = "\033[91m"
WARNINGCOLOUR = '\033[93m'
NOCOLOUR = "\033[0m"

# a list of tuples as such:
#   (
#       "Destination directory as string",
#       [
#           "file1",
#           "file2",
#           "*file_with_glob_*"
#           ("file3", "destinationName")
#       ]
#       lambda file: False  # Optional test to perform. Returning anything other than true will prevent linking.
#                           # Anything other than false will be given as a reason for skipping
#   ]
configs = [
    ("/etc/X11/xorg.conf.d", [
        "./xorg/*"
    ]),
    ("/etc", [
        ("./mpd.conf.KOCHANSKI", "mpd.conf")
    ],
    lambda x: socket.gethostname() == "KOCHANSKI" or "Only for Kochanski"),
    ("/etc", [
        ("./mpd.conf.QUEEG500", "mpd.conf")
    ],
    lambda x: socket.gethostname() == "QUEEG500" or "Only for QUEEG500"),
    ("/etc", ["./mpd.conf"], lambda x: socket.gethostname() == "KOCHANSKI" or "Only for Kochanski"),
    ("$HOME/bin", [
        "./bin/*"
    ]),
    ("$HOME/.config", [
        "./nvim",
        "./terminator",
        "./gitignore_global"
    ]),
    ("$HOME/.config/sxhkd", ["./bspwm/sxhkdrc"]),
    ("$HOME/.config/bspwm", ["./bspwm/bspwmrc"]),
    ("$HOME/.config", ["./rofi"]),
    ("$HOME/.ncmpcpp", [("./ncmpcpp", "config")]),
    ("$HOME", [
        "./.muttrc",
        "./.vimrc",
        "./.Xdefaults",
        "./.xprofile",
        "./.zshrc"
    ]),
    ("$HOME", ["./.xbindkeysrc"], lambda x: socket.gethostname() == "QUEEG500" or "Only for QUEEG500"),
    ("$HOME/.config/polybar", [
        "./polybar/*"
    ]),
    ("$HOME/.config/sublime-text-3/Packages/User", [
        "./sublime/*"
    ]),
    ("$HOME/screenshots", []), # this is only to satisfy the scrot alias in .zshrc
]

# First, check for sudo
sudo_user = None

if "SUDO_USER" in os.environ:
    print(WARNINGCOLOUR, end="")
    sudo_user = os.environ['SUDO_USER']
    sudo_user_uid = pwd.getpwnam(sudo_user).pw_uid
    sudo_user_gid = grp.getgrnam(sudo_user).gr_gid
    print("Running as Root, Detected sudoer as {} (UID {}, GID {})".format(sudo_user, sudo_user_uid, sudo_user_gid))

    oldHome = os.environ["HOME"]
    newHome = os.path.expanduser("~" + sudo_user)

    print("Continuing will change your home directory from {} to {} and chown to {}"
        .format(oldHome, newHome, sudo_user))

    answer = input("Continue? Or Run for [r]oot? (N/y/r) ").lower() or 'n'

    if answer[0] == "y":
        os.environ["HOME"] = newHome

    elif answer[0] == "r":
        pass

    else:
        sys.exit(0)

    print(NOCOLOUR)

# Now get to work on the configs
for config in configs:

    # Get the destination location and expand it, then create it if it doesn't exist
    destination = os.path.expandvars(config[0])
    if not os.path.exists(destination):
      os.makedirs(destination)
      # Chown if nessecary
      if sudo_user:
          os.chown(destination, sudo_user_uid, sudo_user_gid)

    sources = []

    for source in config[1]:

        rename = None

        needsRename = isinstance(source, tuple)

        # If a rename is needed, expand the tupel
        if needsRename:
            (source, rename) = source

        # Expand any globs
        expandedGlobs = glob.glob(source)

        # If we are to rename, but there was a glob that expanded to more than one item, ignore it as we can't rename
        if len(expandedGlobs) > 1 and needsRename:
            print(ERRORCOLOUR, end='')
            print("  => Cannot use renames with GLOB that matches more than one file")
            print("     Source {} matched with {}. Renaming to {} is not possible"
                .format(source, expandedGlobs, rename))
            print(NOCOLOUR, end='')
            continue

        for expandedGlob in expandedGlobs:
            # get the absolute path
            absPath = os.path.abspath(expandedGlob)
            (_, name) = os.path.split(absPath)
            sources.append((absPath, rename or name))

    # Allow tests to be performed on each file, if no test is provided, set a default one
    test = lambda x: True
    if len(config) == 3:
        test = config[2]

    print("Working on directory {}".format(destination))

    try:

        for (source, rename) in sources:

            testResult = test(source)
            if testResult != True:
                print(WARNINGCOLOUR, end='')
                print("  => Skipping Source file {} {}"
                    .format(source, (" Reason: " + testResult if testResult else "")))
                print(NOCOLOUR, end='')
                continue

            # Check the source file exists
            if not os.path.exists(source):
                print(ERRORCOLOUR, end='')
                print("  => ERROR, source file {} does not exist".format(source))
                print(NOCOLOUR, end='')
                continue

            # Get the proposed destination. Any directores provided in the source file location are omitted
            fullDestinationPath = os.path.join(destination, rename)

            try:
                if os.path.islink(fullDestinationPath):
                    print(WARNINGCOLOUR, end='')
                    print("  => Link {} exists, linking to {}, replacing"
                        .format(fullDestinationPath, os.path.realpath(fullDestinationPath)))
                    print(NOCOLOUR, end='')
                    os.unlink(fullDestinationPath)
                    os.symlink(source, fullDestinationPath)

                elif os.path.isfile(fullDestinationPath):
                    print(ERRORCOLOUR, end='')
                    print("  => File {} exists, ignoring".format(fullDestinationPath))
                    print(NOCOLOUR, end='')
                    continue;

                else:
                    print("  => Symlinking {} to {}".format(source, fullDestinationPath))
                    os.symlink(source, fullDestinationPath)

            except OSError as e:
                if e.errno == 13:
                    print(ERRORCOLOUR, end='')
                    print(ERRORCOLOUR + "    => ERROR: Permission denied to symlink {} to {}"
                        .format(source, fullDestinationPath))
                    print(NOCOLOUR, end='')
                else:
                    print(e)

    except OSError as e:
        if e.errno == 13:
            print(ERRORCOLOUR, end='')
            print("  => ERROR: Permission denied to make directory {}".format(destination))
            print(NOCOLOUR, end='')
        else :
            print(e)

print()
print("Also Run:")
print()
print(" # git config --global core.excludesfile ~/.config/gitignore_global")
