{
	# Bootloader configurations
	boot.loader = {
		systemd-boot.enable = true;
		systemd-boot.configurationLimit = 8; # Limit generation entries in boot partition
		timeout = 0;
		efi.canTouchEfiVariables = true;
	};

	# Define the hostname of the machine
	networking.hostName = "adventurers-server";

	# Specify time zone.
	time.timeZone = "Asia/Shanghai";

	# Ignore lid close action to ensure the server runs continously even if the lid is closed
	services.logind.settings.Login = {
		HandleLidSwitch = "ignore";
		HandleLidSwitchExternalPower = "ignore";
	};
}
