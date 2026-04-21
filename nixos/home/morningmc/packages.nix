{ config, pkgs, ... }: {
	# List packages installed in user profile. To search, run:
	# $ nix search <package>
	users.users.morningmc.packages = with pkgs; [
		# Utilities
		kdePackages.dolphin # File explorer
		kdePackages.filelight # Inspect filesystem usage
		microsoft-edge # Web browser
		thunderbird # Email client
		fastfetch
		freerdp # RDP client
		#opendrop # AirDrop client
		qq
		wechat

		# Command-line helpers
		curl
		jq # JSON parser
		fzf # Fuzzy finder
		ripgrep # Used by Neovim for searching
		bc # Basic calculator used in scripts
		grim # Screenshot utility
		brightnessctl # Monitor brightness controller

		# Coding
		# Enable JDK 21 & 17 (latest JDK should be enabled by program.java.enabled)
		jdk21
		jdk17
		# JetBrains IDEs
		jetbrains.idea
		jetbrains.webstorm
		gemini-cli # Gemini command-line client

		# Creative stuff
		(blender.override { cudaSupport = true; })
		blockbench
		gimp2-with-plugins # Image Editor
		kdePackages.kdenlive # Video editor

		# Gaming
		hmcl # Minecraft launcher
	];

	services = {
		# Enable TUN mode of clash core
		mihomo.tunMode = true;
		
		# Enable Weechat (IRC client)
		weechat.enable = true;
		
		# Fix cannot find name for group ID 30000 when building logrotate
		logrotate.checkConfig = false;
	};

	programs = {
		# Enable latest JDK as default Java (currently 25)
		java = {
			enable = true;
			package = pkgs.jdk25;
		};
		
		# Enable Clash Verge Rev
		clash-verge = {
			enable = true;
			tunMode = true;
			serviceMode = true;
		};

		# Enable OBS Studio
		obs-studio = {
			enable = true;
			enableVirtualCamera = true;
		};
	};
}
