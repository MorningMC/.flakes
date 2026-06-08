{ config, lib, ... }: {
	# Declare encrypted secrets
	age.secrets.morningmc-easytier-adventurers.file = ./_secrets/easytier-adventurers.env.age;

	# Enable EasyTier
	services.easytier = {
		enable = true;

		# Define adventurers instance configurations
		instances.adventurers = {
			# Include network secrets
			environmentFiles = [ config.age.secrets.morningmc-easytier-adventurers.path ];

			# Specify IPv4 address allocated
			settings.ipv4 = "10.144.144.1/24";

			# Specify peer nodes to connect on service start
			settings.peers = [
				"tcp://public.easytier.top:11010"
				"tcp://adventurers.morningmc.qzz.io:11010"
				"udp://adventurers.morningmc.qzz.io:11010"
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
	systemd.services.easytier-adventurers.wantedBy = lib.mkForce [ ];
}
