{ lib, pkgs, ... }: let
	# Create wrapper to pass environment variables
	btop-wrapped = pkgs.symlinkJoin {
		name = ".btop-wrapped";
		paths = [ pkgs.btop ];
		buildInputs = [ pkgs.makeWrapper ];
		postBuild = "wrapProgram $out/bin/btop --set LD_LIBRARY_PATH /run/opengl-driver/lib";

		# Pass through the metadata of Btop
		meta = pkgs.btop.meta;
	};
in
{
	# Create wrapper for Btop to monitor graphics cards
	security.wrappers.btop = {
		owner = "root";
		group = "root";
		source = lib.getExe btop-wrapped;
		capabilities = "cap_perfmon=+ep";
	};
}
