{ config, lib, pkgs, ... }: {
    # Declare encrypted secrets used
    age.secrets.builder-qqxnkrut.file = ../_secrets/builder-qqxnkrut.pem.age;

    # Enable remote builds
    nix.distributedBuilds = true;

    # Configure remote build machines
    nix.buildMachines = [
        # frsFallingSand's builder
        {
            # Declare the host name
            hostName = "nix.qqxnkrut.top";

            # The username to log in as on the remote host
            sshUser = "nix-ssh";

            # Declare the SSH private key
            sshKey = config.age.secrets.builder-qqxnkrut.path;

            # Specify the architectures the builder can execute derivations on
            systems = [ "x86_64-linux" ];

            # Use more efficient protocol over SSH
            protocol = "ssh-ng";

            # The base64-encoded public host key of this builder
            publicHostKey = builtins.readFile ./builder-qqxnkrut.pub;

            # The maximum number of concurrent jobs the builder supports
            maxJobs = 16;
        }
    ];

    # Specify SSH options to access nix.qqxnkrut.top
    programs.ssh.extraConfig = ''
        Host nix.qqxnkrut.top
            ProxyCommand ${lib.getExe pkgs.cloudflared} access ssh --hostname %h
            Compression yes
    '';
}
