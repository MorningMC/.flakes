{ config, ... }: {
	# Declare encrypted secrets
	age.secrets.morningmc-easytier-adventurers.file = ./_secrets/easytier-adventurers.env.age;

	# Enable EasyTier
	services.easytier.enable = true;

	# Define adventurers instance configurations
	services.easytier.instances.adventurers = {
		# Include network secrets
		environmentFiles = [ config.age.secrets.morningmc-easytier-adventurers.path ];

		# Specify IPv4 address allocated
		settings.ipv4 = "10.144.144.1/24";

		# Specify peer nodes to connect on service start
		settings.peers = [
			# Official public servers
			"tcp://public.easytier.top:11010"
			"tcp://easytier.public.kkrainbow.top:11010"

			# Self-host server
			"tcp://v4.adventurers.morningmc.qzz.io:11010"
			"udp://v4.adventurers.morningmc.qzz.io:11010"

			# Third-party servers
			# Nodes partially collected from:
			# - https://ruixuan.online/uptime/easytier
			# - https://uptime.lctn.site/status/easytier
			"tcp://easytier.weiai.org.cn:11010"
			"tcp://103.184.47.79:11010"
			"tcp://c.oee.icu:60006"
			"tcp://et.gbc.moe:11010"
			"tcp://turn.nmg.629957.xyz:11010"
			"tcp://weior.top:11010"
			"tcp://ros.scpsl.com.cn:11010"
			"tcp://106.15.202.147:11010"
			"tcp://225284.xyz:11010"
			"udp://225284.xyz:11010"
			"udp://us01.225284.xyz:11010"
			"tcp://183.230.36.171:11010"
			"wss://et.南梁.com"
			"tcp://qic.南梁.com:11010"
			"wss://et.chinokou.cn"
			"tcp://et.sbgov.cn:11010"
			"udp://47.120.54.91:11010"
			"udp://et.basd1.de:22020"
			"tcp://qwe.p8.ink:11010"
			"tcp://37.221.197.17:11010"
			"wss://et.vv1234.cn"
		];
	};
}
