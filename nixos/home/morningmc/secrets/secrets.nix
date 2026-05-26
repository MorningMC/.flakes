# This file should not be imported into the flake as it is only used for the agenix CLI tool to know which public keys to use for encryption

let
	# Declare the public keys used to encrypt secret files
	publicKeys = [
		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID3c/bHNKMBCfGhug0dxUQWM6c4JHiVLilkR8IUu+0QD MorningMC <root@momc.qzz.io>"
		"ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDhno7FyqOALlGhZQ6D4minuWUMH5VjQPBfDOGs2vv+iQmDpOR3E7+fzAETVRusYmOJmLo504eB3XJ/TD0jbNdC7l7RpZVg2PsSPL5ml6/ObSmU8xVcSS+H/uc5ZgWtaU4oQ8heFtMxT7B6zLizUPOW3O7BrG1nO5oYKCsOdaOMuSZBrAJtK8QoxG3++olnKvnzlh1kgYnarl8kH9BBPLzkWhQP2Dt13T283Si2AuQgutKfIQaSK02LJER41gKobjsbn0SzLuU/G+KeOuaUmPi6VzXQiXAS1UgIq8mR5XcOfqa4bioRP5BQkPkll8v63gr9Gi1QLwYEZTe440Xh5joXLjEDMnSDjnMxJpJ4U24zvFTs9GxyXndQMP4sKdjGrFiQL0OpMVoir/6av8VCB7BqGC5uDvHHN4i8KL/cXv86chTf30hxJbvBw4HT/ahoDRHVWo48SY2lL+kFW+sknZbfaivrxs5dJYmL0Q8Ur4vO6jX6WnZ7pjeqsnfRwWWpTZoI6fl+V0IDDJeruZ0gWOdQGWetEkgJQYRrU7VMWrfeM49XT8A5h3PNzUH3CNpFG2VqDszqbgVU6wYPgAj26okSsntscRypZ5IWrTyD0xwxFg83N43rphhsqFPId1g8UAdrQN74NZvBlYZCPgxTK2dK4+64TbDKdlCknUausCo+qw== MorningMC <root@momc.qzz.io>"
	];
in
{
	# Declare secret files to encrypt
	"easytier-local.env.age".publicKeys = publicKeys;
	"docker-windows.env.age".publicKeys = publicKeys;
}
