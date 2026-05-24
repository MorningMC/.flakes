# Fetch the album art of the current playing media and output the path if succeed

# $1: The path where the album art will be stored

# Get the URL of the album art
art_url=$(playerctl metadata --format "{{ mpris:artUrl }}" 2>/dev/null)

# Fetch the URL by cURL and output the path if succeed
curl "$art_url" --silent --output "$1" && echo "$1"
