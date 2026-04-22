# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, flake, ... }: {
	imports = [
		./packages.nix
		./graphics.nix
		./pipewire.nix
		./locale.nix
	];

	# Use vanilla Linux kernel.
	boot.kernelPackages = pkgs.linuxPackages_latest;

	# Enable SysRq functions
	boot.kernel.sysctl."kernel.sysrq" = 1;

	nix = {
		# Enable Nix command & flakes
		settings.experimental-features = [ "nix-command" "flakes" ];

		# Automatically optimise Nix store after building system
		settings.auto-optimise-store = true;

		# Configure Nix store optimizer
		optimise = {
			automatic = true;
			dates = "weekly";
		};
	};

	# Enable system auto-upgrade
	system.autoUpgrade = {
		enable = true;

		# Run at the first day of every month
		dates = "monthly";

		# Use current flake
		inherit flake;

		# Update flake lock (this might cause breakage, but we have backups anyways)
		flags = [
			"--recreate-lock-file"
			"--commit-lock-file"

			# Specify commit message
			"--option"
			"commit-lockfile-summary"
			"chore: update flake lock"
		];

		# Automatically collects garbage
		runGarbageCollection = true;
	};

	# This value determines the NixOS release from which the default
	# settings for stateful data, like file locations and database versions
	# on your system were taken. It‘s perfectly fine and recommended to leave
	# this value at the release version of the first install of this system.
	# Before changing this value read the documentation for this option
	# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
	system.stateVersion = "25.11"; # Did you read the comment?
}
