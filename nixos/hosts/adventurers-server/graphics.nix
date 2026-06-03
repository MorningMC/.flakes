{ lib, ... }: let
	# Utility function to convert standard PCI format to Nix format
	toNixPci = standardPci: let
		parts = builtins.filter builtins.isString (builtins.split "[:.]" standardPci);

		domain = toString (lib.fromHexString (builtins.elemAt parts 0));
		bus = toString (lib.fromHexString (builtins.elemAt parts 1));
		device = toString (lib.fromHexString (builtins.elemAt parts 2));
		function = toString (lib.fromHexString (builtins.elemAt parts 3));
	in
	"PCI:${bus}@${domain}:${device}:${function}";

	# Declare PCI addresses for graphics cards
	integratedCardPci = "0000:00:02.0";
	discreteCardPci = "0000:01:00.0";
in
{
	# Specify Intel & Nvidia PCI address (required by Nvidia PRIME)
	hardware.nvidia.prime = {
		intelBusId = toNixPci integratedCardPci;
		nvidiaBusId = toNixPci discreteCardPci;
	};
}
