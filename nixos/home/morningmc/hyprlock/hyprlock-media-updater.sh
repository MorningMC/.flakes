# Update Hyprlock when media matadata is changed

# Requested metadata format. Only list the metadata keys without additional formats as they are used to trigger updates with
# contents ignored.
requested_format="{{ title }} {{ artist }} {{ album }} {{ status }} {{ position }}"

# Specify sleep interval between updates
sleep_interval=0.3

# Ignore SIGUSR1/SIGUSR2 to prevent unexpected termination
trap "" SIGUSR1 SIGUSR2

# Prevent Hyprlock killed by SIGUSR2 in early stage
sleep "$sleep_interval"

# When any of the requested metadata changed... (Playerctl will output a new updated line and catched by read)
# Playerctl will output a line on command start to report its current state, which makes the while-loop function as a do-while
# and initialize the album art image widget on Hyprlock start.
playerctl metadata --format "$requested_format" --follow | while read -r -s ; do
	# Issue a Hyprlock update
	pkill -SIGUSR2 --exact hyprlock

	# Prevent Hyprlock from deadlock when updating resource too frequent
	sleep "$sleep_interval"
done
