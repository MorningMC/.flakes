# Read image from stdin & search it on Google Lens.
# This script is designed to be used with Noctalia's screenshot IPC command.

# Create a temporary file to store error message
ERR_FILE=$(mktemp)
trap 'rm -f "$ERR_FILE"' EXIT # Register the file to be removed on script exit

# Upload the image to uugu.se, parse the remote URL & search it on Google Lens
RESPONSE=$(curl -fsSLF 'files[]=@-;type=image/png' https://uguu.se/upload 2> "$ERR_FILE") &&
	REMOTE_URL=$(jq -er '.files[0].url | @uri' <<< "$RESPONSE" 2>> "$ERR_FILE") &&
	rm -f "$ERR_FILE" &&
	exec xdg-open "https://lens.google.com/upload?url=$REMOTE_URL"

# The upload failed. Create a notification & exit with error.
noctalia msg notification-show 'Screenshot upload failed!' "$(<"$ERR_FILE")"
exit 1
