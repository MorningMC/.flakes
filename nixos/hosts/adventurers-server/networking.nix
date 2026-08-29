{ config, ... }: {
	# Declare encrypted secrets used
	age.secrets.morningmc_frp-adventurers.file = ./_secrets/frp-adventurers.env.age;
	age.secrets.cloudflare-token-adventurers-server-ddns.file = ./_secrets/cloudflare-token-adventurers-server-ddns.age;

	# Define FRP adventurers instance configurations
	services.frp.instances.adventurers = {
		enable = true;
		role = "client";

		# Include network secrets
		environmentFiles = [ config.age.secrets.morningmc_frp-adventurers.path ];

		# Declare instance configurations
		settings = {
			# Specify destination server
			serverAddr = "v4.adventurers.morningmc.qzz.io";
			serverPort = 7000;

			# Specify authentication method
			auth.method = "token";
			auth.token = "{{ .Envs.AUTH_TOKEN }}"; # Refer to the environment file

			# Reduce latency in an unstable network environment
			transport.protocol = "kcp";

			# Declare proxy tunnels
			proxies = [
				# Create proxy for Minecraft server port
				{
					name = "minecraft-server";
					type = "tcp";
					localIP = "127.0.0.1";
					localPort = 25565;
					remotePort = 25565;
				}

				# Create proxy for Minecraft Simple Voice Chat mod port
				{
					name = "minecraft-voicechat";
					type = "udp";
					localIP = "127.0.0.1";
					localPort = 24454;
					remotePort = 24454;
				}
			];
		};
	};

	# Configure DDNS service
	services.ddclient = {
		enable = true;

		# Specify Cloudflare account token
		protocol = "cloudflare";
		username = "token";
		passwordFile = config.age.secrets.cloudflare-token-adventurers-server-ddns.path;

		# Specify domains to update
		zone = "morningmc.qzz.io";
		domains = [ "adventurers.morningmc.qzz.io" "v6.adventurers.morningmc.qzz.io" ];
		usev4 = ""; # Disable IPv4 address detection as detected IPv4 will be behind a NAT
	};
}
