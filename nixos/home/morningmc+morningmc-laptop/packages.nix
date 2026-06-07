{ config, pkgs, inputs, ... }: {
	# List packages installed in user profile. To search, run:
	# $ nix search <package>
	users.users.morningmc.packages = with pkgs; [
		# Utilities
		kdePackages.dolphin # File explorer
		kdePackages.filelight # Inspect filesystem usage
		microsoft-edge # Web browser
		libreoffice # Office suite
		freerdp # RDP client
		weechat # IRC client
		qq
		wechat
		webcamoid # Webcam capture

		# Command-line helpers
		curl
		bc # Basic calculator used in scripts
		grim # Screenshot utility
		brightnessctl # Monitor brightness controller
		sshfs # Mount remote SFTP file system

		# Creative stuff
		(blender.override { cudaSupport = true; })
		blockbench
		gimp # Image Editor
		kdePackages.kdenlive # Video editor

		# Gaming
		hmcl # Minecraft launcher
	];

	# Enable Clash Verge Rev
	programs.clash-verge = {
		enable = true;
		tunMode = true;
		serviceMode = true;
	};

	home-manager.users.morningmc = {
		# Import nix-index database Home Manager module required by comma
		imports = [ inputs.nix-index-database.homeModules.nix-index ];

		services = {
			# Enable OpenSSH private key agent
			ssh-agent.enable = true;

			# Automatically start GNOME Keyring
			gnome-keyring.enable = true;

			# Enable Policykit agent
			polkit-gnome.enable = true;
		};

		programs = {
			# Enable command-line JSON processor
			jq.enable = true;

			# Enable Ripgrep
			ripgrep.enable = true;

			# Enable Fuzzy Finder
			fzf.enable = true;

			# Enable Fastfetch
			fastfetch.enable = true;

			# Enable comma & nix-index
			nix-index-database.comma.enable = true;
			nix-index.enable = true;

			# Enable OBS Studio
			obs-studio.enable = true;

			# Enable Thunderbird
			thunderbird = {
				enable = true;

				# Fix environment leak when launched from Quickshell.
				package = pkgs.symlinkJoin {
					name = ".thunderbird-wrapper";
					paths = [ pkgs.thunderbird ];
					buildInputs = [ pkgs.makeWrapper ];
					postBuild = "wrapProgram $out/bin/thunderbird --unset NIXPKGS_QT6_QML_IMPORT_PATH";
				};
			};
		};

		# Enable XDG user directories
		xdg.userDirs = {
			enable = true;

			# Export environment variables to session
			setSessionVariables = true;

			# Disable unused directories
			desktop = null;
			publicShare = null;

			# Add custom directories
			extraConfig.WORKSPACES = "${config.users.users.morningmc.home}/Workspaces";
		};
	};

	# Enable Policykit daemon
	security.polkit.enable = true;

	# Enable GNOME Keyring
	services.gnome.gnome-keyring.enable = true;
}
