# Output the battery capacity in percentage and charging status seperated by a space

for battery in /sys/class/power_supply/*BAT*; do
	# Continue the for-loop if $battery/uevent does not exist
	[[ -f "$battery/uevent" ]] || continue

	echo "$(cat "$battery/capacity")% $(cat "$battery/status")"
	break
done
