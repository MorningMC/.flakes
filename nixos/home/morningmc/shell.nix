{ config, pkgs, ... }: {
	# Enable Zsh shell
	programs.zsh.enable = true;

	# Set default shell to Zsh
	users.users.morningmc.shell = pkgs.zsh;

	# Enable Kitty terminal emulator
	home-manager.users.morningmc.programs.kitty = {
		enable = true;

		# Declare font used
		font = {
			name = "JetBrainsMonoNL Nerd Font";
			size = 10;
		};

		# Enable Git integration
		enableGitIntegration = true;

		# Prevent shell integration overriding cursor settings
		shellIntegration.mode = "no-cursor";

		# Extra settings not available in Home Manager's options
		settings = {
			# Disable ligatures
			disable_ligatures = "always";

			# Window settings
			window_padding_width = 8;
			confirm_os_window_close = 0; # Do not confirm when closing

			# Cursor settings
			cursor_shape = "underline";
			cursor_shape_unfocused = "unchanged";
			cursor_underline_thickness = 4;
			cursor_blink_interval = "1 ease";
			cursor_stop_blinking_after = 0;
			cursor_trail = 1;

			# Scroll behavior
			scrollback_lines = 4096;

			# Colors
			selection_foreground = "none";
			selection_background = "none";
			background_opacity = 0.7;
			dynamic_background_opacity = "yes";
		};

		# Declare keybinds
		keybindings = let
			zoomIn = "change_font_size all +1";
			zoomOut = "change_font_size all -1";
			zoomReset = "change_font_size all 0";
		in
		{
			# Copy & paste actions
			"ctrl+c" = "copy_or_interrupt";
			"ctrl+v" = "paste_from_clipboard";
			"ctrl+shift+v" = "send_text all \\x16";

			# Scroll actions
			page_up = "scroll_page_up";
			page_down = "scroll_page_down";

			# Zoom actions
			"ctrl+plus" = zoomIn;
			"ctrl+equal" = zoomIn;
			"ctrl+kp_add" = zoomIn;
			"ctrl+minus" = zoomOut;
			"ctrl+underscore" = zoomOut;
			"ctrl+kp_subtract" = zoomOut;
			"ctrl+0" = zoomReset;
			"ctrl+kp_0" = zoomReset;
		};
	};
}
