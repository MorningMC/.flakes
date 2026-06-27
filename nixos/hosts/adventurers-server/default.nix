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
	networking.hostName = "adventurers-server";

	# Specify time zone
	time.timeZone = "Asia/Shanghai";

	# Ignore lid close action to ensure the server runs continously even if the lid is closed
	services.logind.settings.Login = {
		HandleLidSwitch = "ignore";
		HandleLidSwitchExternalPower = "ignore";
	};
}
