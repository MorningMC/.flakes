{
	# Bootloader configurations
	boot.loader = {
		systemd-boot.enable = true;
		systemd-boot.configurationLimit = 8; # Limit generation entries in boot partition
		timeout = 0;
		efi.canTouchEfiVariables = true;
	};

	# Define the hostname of the machine
	networking.hostName = "morningmc-laptop";

	# Specify time zone.
	time.timeZone = "Asia/Shanghai";

	# Ignore power key action. This prevents others pressing my power key >:(
	services.logind.settings.Login = {
		HandlePowerKey = "ignore";
		HandlePowerKeyLongPress = "ignore";
	};
}
