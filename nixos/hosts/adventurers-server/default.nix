{
	# Bootloader configurations
	boot.loader = {
		# Enable systemd-boot EFI boot manager
		systemd-boot.enable = true;

		# Limit generation entries in boot partition to prevent boot partition running out of disk space
		systemd-boot.configurationLimit = 32;

		# Boot to NixOS directly without displaying the loader menu
		timeout = 0;

		# Allow the installation process to modify EFI boot variables
		efi.canTouchEfiVariables = true;
	};

	# Delete all files in /tmp during boot
	boot.tmp.cleanOnBoot = true;

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
