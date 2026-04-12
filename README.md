# MorningMC's flakes

These are the Nix flakes that i use to build my NixOS system, packages, etc. The flakes are aimed to arrange in a clear and
maintainable way. You might refer to or use these flakes, but some flakes might not fit everyone as these are for my personal use.

Sometimes a `README.md` might be present in the root of a specific flake for further explanation of that flake. See
[`README.md` in `nixos` flake](nixos/README.md) as a example.

## Usage

Each folder under this repository is a Nix flake. You can import a specific flake using

```nix
# Replace <flake> to the name of the specific flake
<flake> = {
    url = "github:MorningMC/.flakes?dir=<flake>";
    inputs.nixpkgs.follows = "nixpkgs"; # Having a consistent Nixpkgs channel is strongly recommened!
};
```

in `inputs` of your flake, or pin to a specific commit using

```nix
# Replace <flake> and <commit> to the name of the specific flake and the full hash of the commit
<flake> = {
    url = "github:MorningMC/.flakes/<commit>?dir=<flake>";
    inputs.nixpkgs.follows = "nixpkgs"; # Having a consistent Nixpkgs channel is strongly recommened!
};
```

. Lock the commit in `flake.lock` is favorable as well.
