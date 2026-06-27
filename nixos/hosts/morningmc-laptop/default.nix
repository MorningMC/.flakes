{
	# Bootloader configurations
	boot.loader = {
		systemd-boot.enable = true;
		systemd-boot.configurationLimit = 8; # Limit generation entries in boot partition
		timeout = 0;
		efi.canTouchEfiVariables = true;
	};

	# /tmp folder configurations
	boot.tmp = {
		# Mount a tmpfs on /tmp during boot
		useTmpfs = true;

		# Expand the size of tmpfs to the size of the physical memory as large Nix builds can fail if the mounted tmpfs is not large enough
		tmpfsSize = "100%";

		# Only allocate huge memory pages if it will be fully within i_size
		tmpfsHugeMemoryPages = "within_size";
	};

	# Define the hostname of the machine
	networking.hostName = "morningmc-laptop";

	# Automatically adjust timezone in terms of geographic location
	services.automatic-timezoned.enable = true;

	# Ignore power key action. This prevents others pressing my power key >:(
	services.logind.settings.Login = {
		HandlePowerKey = "ignore";
		HandlePowerKeyLongPress = "ignore";
	};
}
