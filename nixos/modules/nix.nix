{ config, lib, pkgs, ... }: {
	# Declare encrypted secrets used
	age.secrets.builder-qqxnkrut.file = ./_secrets/builder-qqxnkrut.pem.age;

	nix = {
		settings = {
			# Specify Nix experimental features
			experimental-features = [
				"nix-command" # Enable nix commands
				"flakes" # Enable flakes
			];

			# Optimise Nix store after building system
			auto-optimise-store = true;

			# Enable Noctalia Cachix cache
			extra-substituters = [ "https://noctalia.cachix.org" ];
			extra-trusted-public-keys = [ "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4=" ];
		};

		# Enable remote builds
		distributedBuilds = true;

		# Configure remote build machines
		buildMachines = [
			# frsFallingSand's builder
			{
				# Declare the host name
				hostName = "nix.qqxnkrut.top";

				# The username to log in as on the remote host
				sshUser = "nix-ssh";

				# Declare the SSH private key
				sshKey = config.age.secrets.builder-qqxnkrut.path;

				# Specify the architecturess the builder can execute derivations on
				systems = [ "x86_64-linux" ];

				# Use more efficient protocol over SSH
				protocol = "ssh-ng";

				# The base64-encoded public host key of this builder
				publicHostKey = "c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFDQVFDZ3greURNNG9mSW83a3NiMjJsMElQNjduVmpZREpzeXNxaUdGdE9uNi9xTHhCTDVpdzEwblRITWx1dUQyRUpnVW5EUTRSY3BVdys2MmZUeldaaUFxb0V3dUxWUXdGSm5ScjZ6QnlMNnpDbE52Tk12aDdENEVGWHdmZFVKWnYwcklNNy9sNlJmVk5RRmxsaWVRMFpobklsUU1wRmcvWHZvdkdUL3h1NnlFZHZFMENyN2lqK3M3L0pQUmszaWdaZlUybVNwWHRXQXdhcmRDcWg2RkdqWXF2ck9ubFJHT1BqbVNmQ3FJc0NZSDRlNmxKeTBTY2hGMXQ4TWYxTUNJZGdpUkFjSmNWejJsUlp2K2VXSkdKRDRiYWh2TDA1eGZaSFZZSzdOWXBGZzlpeGtHYTFTYWxRaUFycEpyZnliYWJ3aEZONE1yNEdrdXpDVXdsMFhDaHh6RzQ3MGZkR2RrTUgzaVZjd2FCYXBXUnRpdG9YREcvNGN6WHB0WEZkZGVWTWZ2K0wzbE1lQno0ckFqMk0rU1Y3S1JjU3IvbThkbTYxa0FtSEt4MkVMaWE1RG5qL3hVTDNSbXVRSW51cHoxS3ZZaEdCWkp0a1hIOGIzdTVRR1V4WEQrMGYwQ3pWakhzb2QvMWJXeFVqVGlLT2hFd1hpTlNWTzZpbmI4VGFHZnNrYWxYYkFlblJ0dS9BTjgydHdMZnNZNWhNbFZXamFxRERDNmdzTmVtelZzNmN0Qy9UUDd6cHlpT3FPem4rM0NDNXMrWDdGdXpwb2FFU1VNanhJMEZkOGo3dXlaN2JmdjVkcC9XWjQ0a292YmRrRjV1NFFtWTZocGNnVTQ1cm1FU3RoNnVBT1k2RGxoMXduN05kemw0ODRVZjgrQjA3MmNJanhGRWRSNFBHbWVYTFE9PSByb290QG5peG9zCg==";

				# The maximum number of concurrent jobs the builder supports
				maxJobs = 16;
			}
		];
	};

	# Specify SSH options to access nix.qqxnkrut.top
	programs.ssh.extraConfig = ''
		Host nix.qqxnkrut.top
			ProxyCommand ${lib.getExe pkgs.cloudflared} access ssh --hostname %h
	'';
}
