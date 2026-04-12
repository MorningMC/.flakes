{ config, ... }:

{
	# Set your time zone.
	time.timeZone = "Asia/Shanghai";

	# Configure keymap in X11
	services.xserver.xkb = {
		layout = "us";
		variant = "";
	};
}
