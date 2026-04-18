{ config, pkgs, ... }: let
	# Create wrapper to pass environment variables
	btop-wrapped = pkgs.symlinkJoin {
		name = ".btop-wrapped";
		paths = [ pkgs.btop ];
		buildInputs = [ pkgs.makeWrapper ];
		postBuild = ''
			wrapProgram $out/bin/btop \
			--set LD_LIBRARY_PATH "${config.environment.sessionVariables.LD_LIBRARY_PATH}"
		'';
	};
in
{
	# Create wrapper for Btop to monitor graphics cards
	security.wrappers.btop = {
		owner = "root";
		group = "root";
		source = "${btop-wrapped}/bin/btop";
		capabilities = "cap_perfmon=+ep";
	};
}
