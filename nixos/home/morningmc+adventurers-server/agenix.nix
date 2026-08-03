{ pkgs, inputs, ... }: {
	# Import agenix NixOS module for secret encryption
	imports = [ inputs.agenix.nixosModules.default ];

	# Declare path to host recipient keys
	age.identityPaths = [ "/var/lib/agenix/host_age_pq_key" ];
}
