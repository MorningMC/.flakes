{ flake, ... }: {
    # Enable OpenSSH daemon
    services.openssh.enable = true;

    # Specify authorized OpenSSH public keys
    users.users.morningmc.openssh.authorizedKeys.keys = [
        (builtins.readFile ./id_ed25519.pub)
        (builtins.readFile ./id_rsa.pub)
    ];

    # Enable Git
    home-manager.users.morningmc.programs.git = {
        enable = true;
        lfs.enable = true; # Enable Large File Support

        # Manage Git config with Home Manager
        settings = {
            user.name = "MorningMC";
            user.email = "github@momc.qzz.io";

            init.defaultBranch = "main";
            pull.rebase = false;
        };
    };

    # Enable tmux to connect to Minecraft console socket
    home-manager.users.morningmc.programs.tmux.enable = true;
}
