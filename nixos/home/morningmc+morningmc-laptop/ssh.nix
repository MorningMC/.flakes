{ config, pkgs, ... }: {
    # Enable SSHFS to mount remote SFTP file system
    users.users.morningmc.packages = [ pkgs.sshfs ];

    # Enable OpenSSH private key agent
    home-manager.users.morningmc.services.ssh-agent.enable = true;

    # Enable SSH client configuration
    home-manager.users.morningmc.programs.ssh = {
        enable = true;

        # Do not generate the old default config values as this option will become deprecated in the future
        enableDefaultConfig = false;

        # Declare SSH client configuration
        settings = {
            # Shortcut for Adventurers' Update 2 Server
            adventurers-server.HostName = "10.144.144.10";
            adventurers-server.User = "morningmc";

            # Shortcut for the FRP proxy of Adventurers' Update 2 Server
            adventurers-proxy.HostName = "v4.adventurers.morningmc.qzz.io";
            adventurers-proxy.User = "root";
        };
    };
}
