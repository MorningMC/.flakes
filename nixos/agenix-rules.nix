# This file should not be imported into the flake as it is only used for the agenix CLI tool to know which public keys to use for encryption

let
    # Declare all public keys created for each machine
    hostKeys = {
        # The master key. This key will be used to encrypt all files.
        master = builtins.readFile ./lib/agenix-host-keys/master.pub;

        # The host key of morningmc-laptop
        morningmc-laptop = builtins.readFile ./lib/agenix-host-keys/morningmc-laptop.pub;

        # The host key of adventurers-server
        adventurers-server = builtins.readFile ./lib/agenix-host-keys/adventurers-server.pub;
    };

    # Declare all public keys created for each user
    userKeys = {
        # The master key. This key will be used to encrypt all files.
        master = builtins.readFile ./lib/agenix-user-keys/master.pub;

        # The user key of morningmc+morningmc-laptop
        morningmc_morningmc-laptop = builtins.readFile ./lib/agenix-user-keys/morningmc+morningmc-laptop.pub;
    };

    # The folder name used to store secret files. Should start with a underscore as the secrets should not be included in any flake.
    secretsDir = "_secrets";

    # Import helper functions
    inherit (import ./lib/secrets.nix) mkSecrets;
in

# Declare secret files to encrypt
# Secret files in modules
(mkSecrets "modules/${secretsDir}" (
    builtins.attrValues hostKeys
) [
    "builder-qqxnkrut.pem.age" # SSH private key used to access frsFallingSand's Nix builder
]) //

# Secret files in hosts/adventurers-server
(mkSecrets "hosts/adventurers-server/${secretsDir}" (
    with hostKeys; [ master adventurers-server ]
) [
    "frp-adventurers.env.age" # FRP adventurers instance network secret
    "cloudflare-token-adventurers-server-ddns.age" # Cloudflare account token for DDNS
    "playit-adventurers-server.toml.age" # Playit adventurers-server tunnel secret key
]) //

# Secret files in home/morningmc+morningmc-laptop
(mkSecrets "home/morningmc+morningmc-laptop/${secretsDir}" (
    with hostKeys; [ master morningmc-laptop ]
) [
    "password.age" # Hashed user password
    "easytier-adventurers.env.age" # EasyTier adventurers instance network secret
    "docker-windows.env.age" # Windows Docker container secret
]) //

(mkSecrets "home/morningmc+morningmc-laptop/${secretsDir}" (
    with userKeys; [ master morningmc_morningmc-laptop ]
) [
    "github-token-github-mcp-server.age" # GitHub PAT for GitHub MCP Server
]) //

# Secret files in home/morningmc+adventurers-server
(mkSecrets "home/morningmc+adventurers-server/${secretsDir}" (
    with hostKeys; [ master adventurers-server ]
) [
    "password.age" # Hashed user password
    "easytier-adventurers.env.age" # EasyTier adventurers instance network secret
])
