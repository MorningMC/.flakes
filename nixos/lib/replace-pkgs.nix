{ lib, pkgs, ... }:

/**
    # Description
    Replace variables encoded as `@name@` in a file with the specified values, while automatically translate derivations
    to their executable paths. Values that are not derivations are substituted as they are. This differs with
    `pkgs.replaceVars`, which does not translate the derivations.

    # Inputs
    `src`
        The source file with variables to be replaced.

    `replacements`
        An attribute set containing the variables and their corresponding values. Derivations are automatically
        translated to their executable paths.

    # Type
    ```
    Path -> AttrSet -> Derivation
    ```
*/
src: replacements: let
    # Get the executable path of `value` if `value` is a derivation, or keep it as it is otherwise.
    getExeIfDrv = value: if lib.isDerivation value then lib.getExe value else value;
in
pkgs.replaceVars src (lib.mapAttrs (_: getExeIfDrv) replacements)
