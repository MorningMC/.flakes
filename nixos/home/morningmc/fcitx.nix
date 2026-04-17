{ config, pkgs, ... }: {
	# Enable Fcitx5
	home-manager.users.morningmc.i18n.inputMethod = {
		enable = true;
		type = "fcitx5";
		fcitx5.waylandFrontend = true;

		# Define enabled addons
		fcitx5.addons = with pkgs; [
			fcitx5-rime
			fcitx5-lua
			fcitx5-gtk
			kdePackages.fcitx5-qt
			fcitx5-nord
			fcitx5-pinyin-zhwiki
			qt6Packages.fcitx5-chinese-addons
			qt6Packages.fcitx5-configtool
		];
	};
}
