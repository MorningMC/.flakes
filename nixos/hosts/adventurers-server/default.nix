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

	# Prefer WiFi connection over Ethernet as it has higher speed
	networking.networkmanager.settings = let
		# Utility function to set a specific network interface's metric
		setInterfaceMetric = interface: metric: {
			match-device = "interface-name:" + interface;
			"ipv4.route-metric" = metric;
			"ipv6.route-metric" = metric;
		};
	in
	{
		# Set WiFi interface metric to 100
		connection-wifi = setInterfaceMetric "wlo1" 100;

		# Set Ethernet interface metric to 600
		connection-ethernet = setInterfaceMetric "eno2" 600;
	};

	# Specify time zone.
	time.timeZone = "Asia/Shanghai";

	# Ignore lid close action to ensure the server runs continously even if the lid is closed
	services.logind.settings.Login = {
		HandleLidSwitch = "ignore";
		HandleLidSwitchExternalPower = "ignore";
	};
}
