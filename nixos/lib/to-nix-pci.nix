{ lib, ... }:

/**
    # Description
    Utility function to convert standard PCI format to Nix format.

    # Inputs
    `standardPci`
        PCI address in `<domain>:<bus>:<device>.<function>` form.

    # Type
    ```
    String -> String
    ```
*/
standardPci: let
    # Split standard PCI address into parts
    parts = builtins.filter builtins.isString (builtins.split "[:.]" standardPci);

    # Parse each parts of the PCI address
    domain = toString (lib.fromHexString (builtins.elemAt parts 0));
    bus = toString (lib.fromHexString (builtins.elemAt parts 1));
    device = toString (lib.fromHexString (builtins.elemAt parts 2));
    function = toString (lib.fromHexString (builtins.elemAt parts 3));
in
"PCI:${bus}@${domain}:${device}:${function}"
