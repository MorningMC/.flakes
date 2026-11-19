{ lib, pkgs, ... }: {
    # Specify authorized OpenSSH public keys
    users.users.morningmc.openssh.authorizedKeys.keys = [
        (builtins.readFile ./id_ed25519.pub)
        (builtins.readFile ./id_rsa.pub)
    ];


    home-manager.users.morningmc.programs = {
        # Display some sort of MOTD on SSH login
        bash.enable = true;
        bash.profileExtra = ''
            # Display warnings of service errors
            check-service() {
                # Display the message in red
                systemctl is-active --quiet "$1" || echo -e "\e[31mWARNING: service $1 is dead\e[0m"
            }

            check-service minecraft-server-adventurers-update.service
            check-service frp-adventurers.service
            check-service playit.service

            # I have a cow that can quote proverbs lol
            ${lib.getExe pkgs.fortune} | ${lib.getExe pkgs.cowsay}
        '';

        # Enable Git
        git = {
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
        tmux.enable = true;
    };
}
