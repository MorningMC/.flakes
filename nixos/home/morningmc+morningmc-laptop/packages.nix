{ config, pkgs, inputs, flake, ... }: {
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

	programs = {
		# Enable NH command helper
		nh = {
			enable = true;
			inherit flake; # Use current flake

			# Setup garbage cleaner (this makes nix.gc obsolete)
			clean = {
				enable = true;

				# Perform a clean every day
				dates = "daily";

				# Options given to nh clean
				extraArgs = "--keep 3 --keep-since 7d";
			};
		};

		# Enable Clash Verge Rev
		clash-verge = {
			enable = true;

			# Create XDG autostart desktop entry
			#autoStart = true;

			# Enable Setcap for TUN mode
			tunMode = true;

			# Enable service mode
			serviceMode = true;
		};

		# Enable OBS Studio
		obs-studio = {
			enable = true;

			# Enable CUDA support
			package = pkgs.obs-studio.override { cudaSupport = true; };

			# Setup OBS virtual camera
			enableVirtualCamera = true;

			# Declare installed plugins
			plugins = with pkgs.obs-studio-plugins; [
				# Compat layers
				obs-vaapi # VAAPI support

				# Capture source extension
				obs-pipewire-audio-capture # PipeWire audio device and application capture
				obs-vkcapture # Vulkan/OpenGL game capture
			];
		};
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

			# Enable Thunderbird
			thunderbird.enable = true;
			thunderbird.package = pkgs.symlinkJoin {
				name = ".thunderbird-wrapper";
				paths = [ pkgs.thunderbird ];
				buildInputs = [ pkgs.makeWrapper ];

				# Fix environment leak when launched from Quickshell
				postBuild = "wrapProgram $out/bin/thunderbird --unset NIXPKGS_QT6_QML_IMPORT_PATH";
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
			extraConfig.WORKSPACES = config.users.users.morningmc.home + "/Workspaces";
		};
	};

	# Enable Policykit daemon
	security.polkit.enable = true;

	# Enable GNOME Keyring
	services.gnome.gnome-keyring.enable = true;
}
