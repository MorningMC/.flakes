{ config, pkgs, ... }:

{
	# List packages installed in user profile. To search, run:
	# $ nix search <package>
	users.users.morningmc.packages = with pkgs; [
		# Utilities
		kitty # Terminal emulator
		kdePackages.dolphin # File explorer
		kdePackages.filelight # Inspect filesystem usage
		microsoft-edge # Web browser
		thunderbird # Email client
		btop # System resource monitor
		fastfetch
		freerdp # RDP client
		#opendrop # AirDrop client
		qq
		wechat

		# Command-line helpers
		jq # JSON parser
		fzf # Fuzzy finder
		ripgrep # Used by Neovim for searching
		bc # Basic calculator used in scripts
		slurp # Screenshot utility
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

		# Media stuff
		rmpc # MPD client
		mpd-mpris # Make MPD and other MPRIS controller compatible
		haruna # Media player
		yt-dlp
		cava # Audio Visualizer
	];

	# Set default shell to Zsh
	users.users.morningmc.shell = pkgs.zsh;

	services = {
		# Enable Flatpak
		flatpak.enable = true;

		# Enable MPD
		mpd = {
			enable = true;
			startWhenNeeded = true;
		};
		
		# Enable TUN mode of clash core
		mihomo.tunMode = true;
		
		# Enable Weechat (IRC client)
		weechat.enable = true;
		
		# Fix cannot find name for group ID 30000 when building logrotate
		logrotate.checkConfig = false;
	};

	programs = {
		# Enable Zsh shell
		zsh.enable = true;

		# Enable JDKs
		java.enable = true;
		
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
