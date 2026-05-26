{ config, lib, ... }: {
	# Declare encrypted secrets
	age.secrets.easytier-local.file = ./secrets/easytier-local.env.age;

	# Enable EasyTier
	services.easytier = {
		enable = true;

		# Allow forwarding
		allowSystemForward = true;

		# Define instance configurations
		instances.local = {
			# Includes network secrets
			environmentFiles = [ config.age.secrets.easytier-local.path ];

			# Automatically allocate IP
			settings.dhcp = true;

			# Specify peer nodes to connect on service start
			settings.peers = [
				"tcp://public.easytier.top:11010"
				"tcp://103.184.47.79:11010"
				"tcp://c.oee.icu:60006"
				"tcp://et.gbc.moe:11010"
				"tcp://turn.nmg.629957.xyz:11010"
				"tcp://weior.top:11010"
				"udp://easytier.weiai.org.cn:11010"
				"tcp://ros.scpsl.com.cn:11010"
				"tcp://106.15.202.147:11010"
			];
		};
	};

	# Prevent starting on machine boot
	systemd.services.easytier-local.wantedBy = lib.mkForce [ ];
}
