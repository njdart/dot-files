#!/bin/bash

activity=$(hamster current 2> /dev/null | awk '{print $3" "$4}')

# Foreground color formatting tags are optional
if [[ -n $activity ]]; then
    echo "$activity"    # Match icon color
else
    echo "%{F#65737E}No Activity"  # Greyed out
fi
