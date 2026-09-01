{
    # Use NetworkManager to manage network interfaces
    networking.networkmanager.enable = true;

    # Use modern nftables to replace iptables
    networking.nftables.enable = true;

    # Enable FirewallD
    services.firewalld.enable = true;

    # Enable network name resolution daemon
    services.resolved = {
        enable = true;

        # Enable DoT & DNSSEC if possible
        settings.Resolve.DNSOverTLS = "opportunistic";
        settings.Resolve.DNSSEC = "allow-downgrade";
    };

    # Enable Bluetooth support
    hardware.bluetooth.enable = true;
}
