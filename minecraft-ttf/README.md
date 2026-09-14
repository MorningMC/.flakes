# Nix flake port of `tryashtar/minecraft-ttf`

This flake ports the repository [minecraft-ttf](https://github.com/tryashtar/minecraft-ttf) (or AUR package
[minecraft-ttf-git](https://aur.archlinux.org/packages/minecraft-ttf-git)) to Nix, which is available at
`github:MorningMC/.flakes?dir=minecraft-ttf`.

## Outputs

This flake declares the following outputs under `packages.${system}`, where `${system}` can be any system architecture defined in
[`nixpkgs.lib.systems.flakeExposed`](https://github.com/NixOS/nixpkgs/blob/master/lib/systems/flake-systems.nix):

- `default`: An alias of `minecraft-ttf`. This package will be build by `nix build` without  default
- `minecraft-ttf`: The generated font product. Can be installed to `fonts.packages` in your NixOS configuration. Override options are provided
  to modify specific flags on font generation, see the [source code](default.nix) and
  [Optional Parameters section of upstream README](https://github.com/tryashtar/minecraft-ttf#optional-parameters) for more details.
- `minecraft-ttf-bin`: The compiled binary of the upstream source code. It will be fed to `minecraft-ttf` as an input, but it can also be
  installed to `environment.systemPackages` as separate executable packages.
- `minecraft-ttf-cache`: Pre-processed cache derivation fed to `minecraft-ttf`. It has little usage alone, but it is exported for greater
  customization through overriding and avoids unnecessary cache rebuilding upon upstream changes.

Each outputs except `minecraft-ttf-bin` under different architecture ought, but not guaranteed, to produce identical result. Only `x86_64-linux`
architecture is properly tested. For specific usages of these outputs, refer to the [Usage section of global README](../README.md#usage).

<!--
TODO: Include technical details in the document

## Technical details
### Network access

### Building unfree package
-->
