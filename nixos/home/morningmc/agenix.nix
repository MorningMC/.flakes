{ config, pkgs, inputs, ... }: {
	# Install agenix CLI tool
	users.users.morningmc.packages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];

	# Declare path to host recipient keys
	age.identityPaths = [
		"/etc/ssh/ssh_host_ed25519_key"
		"/etc/ssh/ssh_host_rsa_key"
	];
}
