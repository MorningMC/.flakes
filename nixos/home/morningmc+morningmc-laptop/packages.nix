{ lib, pkgs, inputs, ... }: {
    # List packages installed in user profile. To search, run:
    # $ nix search <package>
    users.users.morningmc.packages = with pkgs; [
        # Utilities
        kdePackages.dolphin # File explorer
        kdePackages.filelight # Inspect filesystem usage
        libreoffice # Office suite
        freerdp # RDP client
        weechat # IRC client
        qq
        wechat
        webcamoid # Webcam capture

        # Command-line helpers
        curl
        bc # Basic calculator used in scripts
        grim # Screenshot utility
        brightnessctl # Monitor brightness controller

        # Creative stuff
        blender
        blockbench
        gimp # Image Editor
        kdePackages.kdenlive # Video editor

        # Gaming
        hmcl # Minecraft launcher
    ];

    # Enable Clash Verge Rev
    programs.clash-verge = {
        enable = true;

        # Create XDG autostart desktop entry
        autoStart = true;

        # Enable Setcap for TUN mode
        tunMode = true;

        # Enable service mode
        serviceMode = true;
    };

    # Enable OBS Studio
    programs.obs-studio = {
        enable = true;

        # Declare installed plugins
        plugins = with pkgs.obs-studio-plugins; [
            # Compat layers
            obs-vaapi # VAAPI support

            # Capture source extension
            obs-pipewire-audio-capture # PipeWire audio device and application capture
            obs-vkcapture # Vulkan/OpenGL game capture

            # Visual filters
            pixel-art # Create retro-inspired pixel art visuals
        ];

        # Setup OBS virtual camera
        enableVirtualCamera = true;
    };

    home-manager.users.morningmc = { config, ... }: {
        imports = [
            # Import nix-index database Home Manager module required by comma
            inputs.nix-index-database.homeModules.nix-index
        ];

        programs = {
            # Enable command-line JSON processor
            jq.enable = true;

            # Enable Ripgrep
            ripgrep.enable = true;

            # Enable Fuzzy Finder
            fzf.enable = true;

            # Enable Fastfetch
            fastfetch.enable = true;

            # Enable comma & nix-index with small database variant
            nix-index-database.comma.enable = true;
            nix-index.package = inputs.nix-index-database.packages.${pkgs.stdenv.hostPlatform.system}.nix-index-with-small-db;

            # Enable Brave
            brave.enable = true;

            # Enable Thunderbird
            thunderbird.enable = true;

            # Enable Qalculate!
            qalculate.enable = true;
            qalculate.package = pkgs.qalculate-qt; # Install the Qt variant
        };

        # Make user Nix profiles respect XDG base directories
        nix.assumeXdg = config.home.preferXdgDirectories;
    };

    # Create wrapper for Btop to monitor graphics cards
    security.wrappers.btop = {
        # Specify the target executable to be wrapped
        source = lib.getExe pkgs.btop;

        # Specify the owner & the group of the wrapper program
        owner = "root";
        group = "root";

        # Allows Btop to monitor system performance
        capabilities = "cap_perfmon=+ep";
    };
}
