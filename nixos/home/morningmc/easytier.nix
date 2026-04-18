{ config, ... }: {
	# Enable EasyTier
	services.easytier = {
		enable = true;

		# Allow forwarding
		allowSystemForward = true;

		# Define instance configurations
		instances.local = {
			environmentFiles = [ "/home/morningmc/.flakes/nixos/home/morningmc/easytier.env.secret" ]; # Includes network secrets
			settings.dhcp = true; # Automatically allocate IP
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
}
