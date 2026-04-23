#!/bin/bash
# Execute arbitrary shell commands

# Get command from argument or stdin
COMMAND="${1:-$(cat)}"

if [ -z "$COMMAND" ]; then
    echo "Error: No command provided"
    exit 1
fi

# Execute the command
echo "Executing: $COMMAND"
echo "---"
eval "$COMMAND"
EXIT_CODE=$?

echo "---"
echo "Exit code: $EXIT_CODE"
exit $EXIT_CODE
