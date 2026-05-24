# Update Hyprlock when media matadata is changed

# Requested metadata format. Only list the metadata keys without additional formats as they are used to trigger updates with
# contents ignored.
requested_format="{{ title }} {{ artist }} {{ album }} {{ status }} {{ position }}"

# Ignore SIGUSR1/SIGUSR2 to prevent unexpected termination
trap : SIGUSR1 SIGUSR2

# When any of the requested metadata changed... (Playerctl will output a new updated line and catched by read)
playerctl metadata --format "$requested_format" --follow | while read -r -s; do
	# Issue a Hyprlock update
	pkill -SIGUSR2 --exact hyprlock
done
