{ config, pkgs, ... }: {
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

		# Command-line helpers
		curl
		bc # Basic calculator used in scripts
		grim # Screenshot utility
		brightnessctl # Monitor brightness controller

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

	home-manager.users.morningmc.programs = {
		# Enable command-line JSON processor
		jq.enable = true;

		# Enable Ripgrep
		ripgrep.enable = true;

		# Enable Fuzzy Finder
		fzf = {
			enable = true;
			enableZshIntegration = true;
		};

		# Enable Fastfetch
		fastfetch.enable = true;

		# Enable OBS Studio
		obs-studio.enable = true;

		# Enable Thunderbird
		thunderbird = {
			enable = true;

			# Fix environment leak when launched from Quickshell.
			package = (pkgs.symlinkJoin {
				name = ".thunderbird-wrapper";
				paths = [ pkgs.thunderbird ];
				buildInputs = [ pkgs.makeWrapper ];
				postBuild = "wrapProgram $out/bin/thunderbird --unset NIXPKGS_QT6_QML_IMPORT_PATH";
			});
		};
	};
}
