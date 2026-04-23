#!/bin/bash
# Open a new terminal and execute a command

COMMAND="${1:-$(cat)}"

if [ -z "$COMMAND" ]; then
    echo "Error: No command provided"
    exit 1
fi

# Try different terminal emulators
if command -v xfce4-terminal &> /dev/null; then
    xfce4-terminal -e "bash -c '$COMMAND; echo; echo Press Enter to close...; read'" &
    echo "Opened Xfce Terminal with command: $COMMAND"
elif command -v gnome-terminal &> /dev/null; then
    gnome-terminal -- bash -c "$COMMAND; echo; echo 'Press Enter to close...'; read" &
    echo "Opened GNOME Terminal with command: $COMMAND"
elif command -v xterm &> /dev/null; then
    xterm -hold -e bash -c "$COMMAND" &
    echo "Opened XTerm with command: $COMMAND"
elif command -v konsole &> /dev/null; then
    konsole -e bash -c "$COMMAND; echo; echo 'Press Enter to close...'; read" &
    echo "Opened Konsole with command: $COMMAND"
else
    echo "Error: No terminal emulator found"
    exit 1
fi

exit 0
