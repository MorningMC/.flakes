{ config, pkgs, ... }: {
	fonts = {
		# Enable backward portability
		fontDir.enable = true;

		# Enable builtin fonts
		enableDefaultPackages = true;
		
		# Additional font packages
		packages = with pkgs; [
			nerd-fonts.jetbrains-mono
			noto-fonts
			noto-fonts-cjk-sans
			noto-fonts-cjk-serif
			noto-fonts-color-emoji
		];
	};
}
