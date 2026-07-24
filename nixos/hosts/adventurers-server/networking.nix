{ config, ... }: {
	# Declare encrypted secrets used
	age.secrets.cloudflare-token-adventurers-server-ddns.file = ./_secrets/cloudflare-token-adventurers-server-ddns.age;

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
}
