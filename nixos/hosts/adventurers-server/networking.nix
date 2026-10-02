{ config, inputs, ... }: {
    # Import Playit Agent module
    imports = [ inputs.playit-nixos-module.nixosModules.default ];

    # Declare encrypted secrets used
    age.secrets.cloudflare-token-adventurers-server-ddns.file = ./_secrets/cloudflare-token-adventurers-server-ddns.age;
    age.secrets.playit-adventurers-server.file = ./_secrets/playit-adventurers-server.toml.age;

    # Configure DDNS service
    services.ddclient = {
        enable = true;

        # Specify Cloudflare account token
        protocol = "cloudflare";
        username = "token";
        passwordFile = config.age.secrets.cloudflare-token-adventurers-server-ddns.path;

        # Specify domains to update
        zone = "morningmc.qzz.io";
        domains = [ "adventurers.morningmc.qzz.io" "v6.adventurers.morningmc.qzz.io" ];
        usev4 = ""; # Disable IPv4 address detection as detected IPv4 will be behind a NAT
    };

    # Configure Playit Agent
    services.playit.enable = true;
    services.playit.secretPath = config.age.secrets.playit-adventurers-server.path;
}
