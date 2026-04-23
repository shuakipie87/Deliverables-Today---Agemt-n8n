#!/bin/bash
# Open a new terminal window

# Try different terminal emulators
if command -v xfce4-terminal &> /dev/null; then
    xfce4-terminal &
    echo "Opened Xfce Terminal"
elif command -v gnome-terminal &> /dev/null; then
    gnome-terminal &
    echo "Opened GNOME Terminal"
elif command -v xterm &> /dev/null; then
    xterm &
    echo "Opened XTerm"
elif command -v konsole &> /dev/null; then
    konsole &
    echo "Opened Konsole"
else
    echo "Error: No terminal emulator found"
    exit 1
fi

exit 0
