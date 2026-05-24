# Output the appropriate play/pause icon based on the player status

# Get the current player status
status=$(playerctl status 2>/dev/null)

if [[ "$status" == "Playing" ]]; then
    # Playing icon
    echo ""
elif [[ "$status" == "Paused" ]]; then
    # Paused icon
    echo ""
else
    # Stopped or no player running
    echo ""
fi
