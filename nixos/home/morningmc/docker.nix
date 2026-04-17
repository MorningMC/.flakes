{ config, pkgs, ... }: {
	# Enable Docker
	virtualisation.docker.enable = true;

	# Make the user accessible to docker containers
	users.users.morningmc.extraGroups = [ "docker" ];

	# Enable Docker compose
	users.users.morningmc.packages = with pkgs; [ docker-compose ];
}
