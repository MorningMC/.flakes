{ config, pkgs, lib, ... }: {
	# Enable Z Shell
	programs.zsh.enable = true;

	# Set default shell to Zsh
	users.users.morningmc.shell = pkgs.zsh;

	# Manage Z Shell by Home Manager
	home-manager.users.morningmc.programs.zsh = {
		enable = true;

		# Automatically enter into a directory if typed directly into shell
		autocd = true;

		# Enable autosuggestions
		autosuggestion.enable = true;

		# Enable syntax highlighting
		syntaxHighlighting.enable = true;

		# Enable history substring search
		historySubstringSearch = {
			enable = true;

			# Map up and down keys
			searchUpKey = [ "$terminfo[kcuu1]" ];
			searchDownKey = [ "$terminfo[kcud1]" ];
		};

		# Declare aliases
		shellAliases = {
			sudo = "sudo -E";
			ff = "fastfetch";
			hypr = "start-hyprland";
		};

		# Configure Oh My Zsh
		oh-my-zsh = {
			enable = true;
			theme = "bira"; # Specify shell theme
			plugins = [ "git" "sudo" "kitty" ];
		};

		# Manage plugins with Zplug
		zplug = {
			enable = true;
			plugins = [
				{ name = "Aloxaf/fzf-tab"; }
			];
		};

		# Launch Fastfetch in an interactive shell and not already marked
		initContent = lib.mkAfter ''
			if [[ $(tty) != /dev/tty* ]] && [[ -z "$__SHELL_SESSION" ]]; then
				export __SHELL_SESSION=1
				clear
				fastfetch
			fi
		'';
	};

	# Get Zsh completion for system packages
	environment.pathsToLink = [ "/share/zsh" ];
}
