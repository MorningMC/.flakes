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
            (inputs.minecraft-ttf.packages.${stdenv.hostPlatform.system}.default.override {
                # Generate for all types of font
                identifiers = [ "minecraft:default" "minecraft:alt" "minecraft:illageralt" "minecraft:uniform" ];

                # Generate for all styles
                styles = [ "regular" "bold" "italic" "bold_italic" ];

                # Include printable characters on Unicode plane 0 in uniform font
                unifont-chars = "0200-d7ff,e000-fffd";
            })

            # Alternative pixel fonts
            ark-pixel-font
        ];
    };
}
