{ pkgs, inputs, ... }: {
	fonts = {
		# Enable backward portability
		fontDir.enable = true;

		# Enable builtin fonts
		enableDefaultPackages = true;

		# Additional font packages
		packages = with pkgs; [
			# JetbrainsMono Nerd Font
			nerd-fonts.jetbrains-mono

			# Noto Fonts with CJK and emoji support
			noto-fonts
			noto-fonts-cjk-sans
			noto-fonts-cjk-serif
			noto-fonts-color-emoji

			# Windows fonts
			vista-fonts

			# Minecraft fonts
			inputs.minecraft-ttf.packages.${stdenv.hostPlatform.system}.default
			unifont # Minecraft uniform font
		];
	};
}
