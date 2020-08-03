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
SUCCESS_COLOUR = '\033[32m'
NOCOLOUR = "\033[0m"

# a list of tuples as such:
#   (
#       "Destination directory as string",
#       [
#           "file1",
#           "file2",
#           "*file_with_glob_*"
#           ("file3", "destinationName")
#       ],
#       lambda file: False  # Optional test to perform. Returning anything other than true will prevent linking.
#                           # Anything other than false will be given as a reason for skipping
#   )
configs = [
    # # These resources will require root privileges to link
    # ("/etc/X11/xorg.conf.d", [
    #     "./xorg/*"
    # ]),

    # User config
    ("$HOME", [
        "./bin",
        "./.xprofile",
        "./.zshrc",
        "./.tmux.conf"
    ]),

    ("$HOME/.config", [
        "./nvim",
        "./terminator",
        "./gitignore_global",
        "./rofi",
        "./dunst",
        "./polybar",
        "./picom.conf",
        "./systemd"
    ]),

    ("$HOME/.config/mpv", ["mpv.conf"]),
    ("$HOME/.config/sxhkd", ["./bspwm/sxhkdrc"]),
    ("$HOME/.config/bspwm", ["./bspwm/bspwmrc"]),
    ("$HOME/.config/Code", ["./vscode/User"]),

    # Create the screenshot directory for the scrot alias in .zshrc
    ("$HOME/screenshots", []),
]

def checkOrMakeDestination(destination):
    try:
        if not os.path.exists(destination):
            os.makedirs(destination)
            return True
    except OSError as e:
        if e.errno == 13:
            print(ERRORCOLOUR, end='')
            print("  => ERROR: Permission denied to make directory {}".format(destination))
            print(NOCOLOUR, end='')
        else:
            print(e)
        return False

def normaliseSourceFiles(sources):
    expanded_sources = []

    for source in sources:

        # If a rename is needed, we can skip normalising the sourcesappend the results to the end
        if isinstance(source, tuple):
            expanded_sources.append(source)

        # Else, check for globs
        else:
            expandedGlobs = glob.glob(source)

            # for each found item in the glob, push a tuple with the "rename"
            # argument the same as the current name to simplify moving later on
            for expandedGlob in expandedGlobs:

                absPath = os.path.abspath(expandedGlob)
                (_, name) = os.path.split(absPath)

                expanded_sources.append((absPath, name))

    return expanded_sources

def symblinkSources(destination, sources, test):

    try:
        for (source, rename) in sources:

            # First, run the test, and print the warning or reason if we're skipping
            test_result = test(source)
            if test_result != True:
                print(WARNINGCOLOUR, end='')
                print("  => Skipping Source file {} {}"
                      .format(source, (" Reason: " + test_result if test_result else "")))
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
                    linkDestination = os.readlink(fullDestinationPath)
                    if linkDestination == source:
                        print("  => Link {} already exists".format(fullDestinationPath))
                    else:
                        print(WARNINGCOLOUR, end='')
                        print("  => Link {} already exists, linking to {}. Re-linking to {}"
                            .format(fullDestinationPath, linkDestination, source))
                        print(NOCOLOUR, end='')
                        os.unlink(fullDestinationPath)
                        os.symlink(source, fullDestinationPath)

                elif os.path.isfile(fullDestinationPath):
                    print(ERRORCOLOUR, end='')
                    print("  => File {} exists, ignoring".format(
                        fullDestinationPath))
                    print(NOCOLOUR, end='')
                    continue

                else:
                    print(SUCCESS_COLOUR, end='')
                    print("  => Symlinking {} to {}".format(
                        source, fullDestinationPath))
                    print(NOCOLOUR, end='')
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
            print("  => ERROR: Permission denied to make directory {}".format(
                destination))
            print(NOCOLOUR, end='')
        else:
            print(e)

# Now get to work on the configs
for config in configs:

    test = lambda x: True

    if len(config) == 3:
        (destination, sources, test) = config
    else:
        (destination, sources) = config

    destination = os.path.expandvars(destination)

    if checkOrMakeDestination(destination) == False:
        continue

    print("Working on directory {}".format(destination))

    sources = normaliseSourceFiles(sources)

    symblinkSources(destination, sources, test)


print()
print("Also Run:")
print()
print(" # git config --global core.excludesfile ~/.config/gitignore_global")
print()
print(" # bash ./vscode/extensions")
