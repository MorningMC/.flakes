{ pkgs, inputs, flake, ... }: {
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
        (blender.override { cudaSupport = true; })
        blockbench
        gimp # Image Editor
        kdePackages.kdenlive # Video editor

        # Gaming
        hmcl # Minecraft launcher
    ];

    programs = {
        # Enable NH command helper
        nh = {
            enable = true;
            inherit flake; # Use current flake

            # Setup garbage cleaner (this makes nix.gc obsolete)
            clean = {
                enable = true;

                # Perform a clean every day
                dates = "daily";

                # Options given to nh clean
                extraArgs = "--keep 3 --keep-since 7d";
            };
        };

        # Enable Clash Verge Rev
        clash-verge = {
            enable = true;

            # Create XDG autostart desktop entry
            autoStart = true;

            # Enable Setcap for TUN mode
            tunMode = true;

            # Enable service mode
            serviceMode = true;
        };

        # Enable OBS Studio
        obs-studio = {
            enable = true;

            # Enable CUDA support
            package = pkgs.obs-studio.override { cudaSupport = true; };

            # Declare installed plugins
            plugins = with pkgs.obs-studio-plugins; [
                # Compat layers
                obs-vaapi # VAAPI support

                # Capture source extension
                obs-pipewire-audio-capture # PipeWire audio device and application capture
                obs-vkcapture # Vulkan/OpenGL game capture
            ];

            # Setup OBS virtual camera
            enableVirtualCamera = true;
        };
    };

    # Import nix-index database Home Manager module required by comma
    home-manager.users.morningmc.imports = [ inputs.nix-index-database.homeModules.nix-index ];

    home-manager.users.morningmc.programs = {
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
}
