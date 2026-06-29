{ pkgs, inputs, ... }: {
	# Import nix-minecraft module
	imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];

	# Allow current user to manage Minecraft servers
	users.users.morningmc.extraGroups = [ "minecraft" ];

	# Enable Minecraft servers
	services.minecraft-servers = {
		enable = true;

		# Agree to Mojang's EULA. This option must be set to true to run any Minecraft servers.
		eula = true;

		# Open firewall ports
		openFirewall = true;

		# Declare adventurers-update server instance
		servers.adventurers-update = {
			enable = true;

			# Use 1.21.1 latest NeoForge server
			package = pkgs.minecraftServers.neoforge-1_21_1;

			# Declare additional JVM optopns
			jvmOpts = [
				"-Xmx24G" # Allow a maximum of 24 GiB memory usage
				"-XX:+UseZGC" "-XX:+ZGenerational" # Use ZGC as garbage cleaner
			];

			# Declare server configurations
			serverProperties = {
				# Specify Message of the Day
				motd = "\\u00A7aAdventurers' Update \\u00A7b2 \\u00A7aServer\\u00A7r Experimental Period \\u00A7f2\\u00A7r\\n" +
					"Running modpack version \\u00A762.0.0-unstable-2026-06-10";

				# Use offline authentication. Players are identified only by their names.
				online-mode = false;

				# Set difficulty to hard
				difficulty = "hard";

				# Allow a maximum of 200 simultaneous players on the server
				max-players = 200;

				# Minimize operator permissions. An operator must use the console to execute commands.
				op-permission-level = 0;
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
