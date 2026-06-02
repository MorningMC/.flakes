{ pkgs, inputs, ... }: {
	# Import agenix module for secret encryption
	imports = [ inputs.agenix.nixosModules.default ];

	# Install agenix CLI tool
	users.users.morningmc.packages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];

	# Declare path to host recipient keys
	age.identityPaths = [ "/var/lib/agenix/host_age_pq_key" ];
}
