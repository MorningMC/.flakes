{ pkgs, inputs, ... }: {
	# Import agenix NixOS module for secret encryption
	imports = [ inputs.agenix.nixosModules.default ];

	# Declare path to host recipient keys
	age.identityPaths = [ "/var/lib/agenix/host_age_pq_key" ];

	# Install agenix CLI tool
	users.users.morningmc.packages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];

	home-manager.users.morningmc.services = {
		# Enable OpenSSH private key agent
		ssh-agent.enable = true;

		# Automatically start GNOME Keyring
		gnome-keyring.enable = true;

		# Enable Policykit agent
		polkit-gnome.enable = true;
	};

	# Enable Policykit daemon
	security.polkit.enable = true;

	# Enable GNOME Keyring
	services.gnome.gnome-keyring.enable = true;
}
