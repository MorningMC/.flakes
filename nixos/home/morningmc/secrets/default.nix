{ config, pkgs, inputs, ... }: {
	# Install agenix CLI tool
	users.users.morningmc.packages = [ inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default ];

	# Declare path to recipient keys
	age.identityPaths = [
		"${config.users.users.morningmc.home}/.ssh/id_ed25519"
		"${config.users.users.morningmc.home}/.ssh/id_rsa"
	];
}
