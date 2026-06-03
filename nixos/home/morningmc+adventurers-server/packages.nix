{
	# Enable OpenSSH daemon
	services.openssh.enable = true;

	# Specify authorized OpenSSH public keys
	users.users.morningmc.openssh.authorizedKeys.keys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3c/bHNKMBCfGhug0dxUQWM6c4JHiVLilkR8IUu+0QD MorningMC <root@momc.qzz.io>"
		"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhno7FyqOALlGhZQ6D4minuWUMH5VjQPBfDOGs2vv+iQmDpOR3E7+fzAETVRusYmOJmLo504eB3XJ/TD0jbNdC7l7RpZVg2PsSPL5ml6/ObSmU8xVcSS+H/uc5ZgWtaU4oQ8heFtMxT7B6zLizUPOW3O7BrG1nO5oYKCsOdaOMuSZBrAJtK8QoxG3++olnKvnzlh1kgYnarl8kH9BBPLzkWhQP2Dt13T283Si2AuQgutKfIQaSK02LJER41gKobjsbn0SzLuU/G+KeOuaUmPi6VzXQiXAS1UgIq8mR5XcOfqa4bioRP5BQkPkll8v63gr9Gi1QLwYEZTe440Xh5joXLjEDMnSDjnMxJpJ4U24zvFTs9GxyXndQMP4sKdjGrFiQL0OpMVoir/6av8VCB7BqGC5uDvHHN4i8KL/cXv86chTf30hxJbvBw4HT/ahoDRHVWo48SY2lL+kFW+sknZbfaivrxs5dJYmL0Q8Ur4vO6jX6WnZ7pjeqsnfRwWWpTZoI6fl+V0IDDJeruZ0gWOdQGWetEkgJQYRrU7VMWrfeM49XT8A5h3PNzUH3CNpFG2VqDszqbgVU6wYPgAj26okSsntscRypZ5IWrTyD0xwxFg83N43rphhsqFPId1g8UAdrQN74NZvBlYZCPgxTK2dK4+64TbDKdlCknUausCo+qw== MorningMC <root@momc.qzz.io>"
	];

	# Enable Docker
	virtualisation.docker = {
		enable = true;

		# Enable rootless mode
		rootless.enable = true;
		rootless.setSocketVariable = true;
	};

	# Enable dynamic CDI configuration for Nvidia devices
	hardware.nvidia-container-toolkit.enable = true;

	# Make the user accessible to docker containers
	users.users.morningmc.extraGroups = [ "docker" ];

	home-manager.users.morningmc.programs = {
		# Enable Git
		git = {
			enable = true;
			lfs.enable = true; # Enable Large File Support

			# Manage Git config with Home Manager
			settings = {
				user.name = "MorningMC";
				user.email = "github@momc.qzz.io";

				init.defaultBranch = "main";
				pull.rebase = false;
			};
		};

		# Enable LazyGit
		lazygit.enable = true;

		# Enable Java Development Kit
		java.enable = true;
	};
}
