{ config, pkgs, inputs, ... }: {
	# Import nix-minecraft module and its corresponding Nixpkgs overlay
	imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
	nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];

	# Declare encrypted secrets
	age.secrets.morningmc-minecraft-server.file = ./_secrets/minecraft-server.env.age;

	# Allow current user to manage Minecraft servers
	users.users.morningmc.extraGroups = [ "minecraft" ];

	# Enable Minecraft servers
	services.minecraft-servers = {
		enable = true;

		# Agree to Mojang's EULA. This option must be set to true to run any Minecraft servers.
		eula = true;

		# Open firewall ports
		openFirewall = true;

		# Include RCON secrets
		environmentFile = config.age.secrets.morningmc-minecraft-server.path;

		# Declare adventurers-update server instance
		servers.adventurers-update = {
			enable = true;

			# Use 1.21.1 latest NeoForge server
			package = pkgs.minecraftServers.neoforge-1_21_1;

			# Declare additional JVM optopns
			jvmOpts = [
				"-Xmx16G" # Allow a maximum of 16 GiB memory usage
				"-XX:+UseZGC" "-XX:+ZGenerational" # Use ZGC as garbage cleaner
			];

			# Declare server configurations
			serverProperties = {
				# Specify Message of the Day
				motd = "Adventurers' Update 2 Server Experiment Period 2";

				# Use offline authentication. Players are identified only by their names.
				online-mode = false;

				# Set difficulty to hard
				difficulty = "hard";

				# Allow a maximum of 200 simultaneous players on the server
				max-players = 200;

				# Minimize operator permissions. An operator must use the console to execute commands.
				op-permission-level = 0;

				# Configure RCON
				enable-rcon = true;
				"rcon.password" = "%ADVENTURERS_UPDATE_RCON_PASSWORD%"; # Refer to the environment file
			};
		};
	};

	home-manager.users.morningmc.programs = {
		# Enable tmux to connect to Minecraft console socket
		tmux.enable = true;

		# Enable Java Development Kit
		java.enable = true;
	};
}
