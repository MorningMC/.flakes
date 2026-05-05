{ config, pkgs, ... }: {
	users.users.morningmc.packages = with pkgs; [
		# JDK 21 & 17 (latest JDK should be enabled by program.java.enabled)
		jdk21
		jdk17

		# Python runtimes
		python3

		# JetBrains IDEs
		jetbrains.idea
		jetbrains.webstorm

		commitlint # Git commit message style check
	];

	home-manager.users.morningmc.programs = {
		# Enable Git
		git = {
			enable = true;
			lfs.enable = true; # Enable Large File Support

			# Use full version of Git to include libsecret credential helper
			package = pkgs.gitFull;

			# Manage Git config with Home Manager
			settings = {
				user.name = "MorningMC";
				user.email = "github@momc.qzz.io";

				core.hooksPath = "/home/morningmc/.config/scripts/githooks";
				credential.helper = "libsecret";
				init.defaultBranch = "main";
				pull.rebase = false;
			};
		};

		# Enable LazyGit
		lazygit.enable = true;

		# Enable latest JDK as default Java (currently 25)
		java = {
			enable = true;
			package = pkgs.jdk25;
		};

		# Enable Gradle
		gradle.enable = true;

		# Enable Gemini command-line client
		gemini-cli.enable = true;
	};
}
