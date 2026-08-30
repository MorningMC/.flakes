{ config, ... }: {
	# Declare encrypted secrets
	age.secrets.morningmc_easytier-adventurers.file = ./_secrets/easytier-adventurers.env.age;

	# Enable EasyTier
	services.easytier.enable = true;

	# Define adventurers instance configurations
	services.easytier.instances.adventurers = {
		# Include network secrets
		environmentFiles = [ config.age.secrets.morningmc_easytier-adventurers.path ];

		# Specify IPv4 address allocated
		settings.ipv4 = "10.144.144.1/24";

		# Specify peer nodes to connect on service start
		settings.peers = import ../../lib/easytier-nodes.nix;
	};
}
