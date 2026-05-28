# Fetch the album art of the current playing media and output the path if succeed

# Specify the path where the album art will be stored
art_path="/tmp/hyprlock-album-art.png"

# Get the URL of the album art
art_url="$(playerctl metadata --format "{{ mpris:artUrl }}" 2>/dev/null)"

# If the URL is empty...
if [[ -z "$art_url" ]]; then
	# Exit the script with no output (display nothing in the image widget)
	exit 0
fi

# Fetch the URL and trim the image to a square. Output the path if succeed.
curl --silent --location "$art_url" | magick - -gravity Center -extent 1:1 "$art_path" && echo "$art_path"
