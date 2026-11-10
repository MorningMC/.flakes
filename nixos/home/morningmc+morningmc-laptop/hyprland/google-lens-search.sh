# Read image from stdin & search it on Google Lens.
# This script is designed to be used with Noctalia's screenshot IPC command.

# Upload the image to uugu.se & get the remote URL
REMOTE_URL=$(curl -s -F 'files[]=@/dev/stdin' https://uguu.se/upload | jq -r '.files[0].url')

# If the upload is successful...
if [[ -n "$REMOTE_URL" ]]; then
	# Search it on Google Lens
	exec xdg-open "https://lens.google.com/upload?url=$REMOTE_URL"
fi

# The upload failed. Create a notification & exit with error.
noctalia msg notification-show 'Screenshot upload failed!'
exit 1
