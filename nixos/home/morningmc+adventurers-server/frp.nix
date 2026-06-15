{ config, ... }: {
	# Declare encrypted secrets
	age.secrets.morningmc-frp-adventurers.file = ./_secrets/frp-adventurers.env.age;

	# Define FRP adventurers instance configurations
	services.frp.instances.adventurers = {
		enable = true;
		role = "client";

		# Include network secrets
		environmentFiles = [ config.age.secrets.morningmc-frp-adventurers.path ];

		# Declare instance configurations
		settings = {
			# Specify destination server
			serverAddr = "adventurers.morningmc.qzz.io";
			serverPort = 7000;

			# Specify authentication method
			auth.method = "token";
			auth.token = "{{ .Envs.AUTH_TOKEN }}"; # Refer to the environment file

			# Declare proxy tunnels
			proxies = [
				# Create proxy for Minecraft server port
				{
					name = "minecraft-server";
					type = "kcp"; # Replace TCP to reduce latency in an unstable network environment
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
}
