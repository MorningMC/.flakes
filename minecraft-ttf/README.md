# Nix flake port of `tryashtar/minecraft-ttf`

This flake ports the repository [minecraft-ttf](https://github.com/tryashtar/minecraft-ttf) (or AUR package
[minecraft-ttf-git](https://aur.archlinux.org/packages/minecraft-ttf-git)) to Nix, which is available at
`github:MorningMC/.flakes?dir=minecraft-ttf`.

## Outputs

This flake declares the output at `packages.${system}.default`, where `${system}` can be any system architecture defined in
[`nixpkgs.lib.systems.flakeExposed`](https://github.com/NixOS/nixpkgs/blob/master/lib/systems/flake-systems.nix), at the time of writing this
file, namely as follows:

- `x86_64-linux`
- `aarch64-linux`
- `x86_64-darwin`
- `armv6l-linux`
- `armv7l-linux`
- `i686-linux`
- `aarch64-darwin`
- `powerpc64le-linux`
- `riscv64-linux`
- `x86_64-freebsd`

These outputs ought, but not guaranteed, to produce identical result. Only `x86_64-linux` architecture is properly tested. For specific usages
of these outputs, refer to the Usage section of [global README](../README.md).

<!--
TODO: Include technical details in the document

## Technical details
### Network access

### Building unfree package
-->
