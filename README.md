# MorningMC's flakes
![GitHub License](https://img.shields.io/github/license/MorningMC/.flakes?style=for-the-badge)
![GitHub last commit](https://img.shields.io/github/last-commit/MorningMC/.flakes?style=for-the-badge)
![GitHub repo size](https://img.shields.io/github/repo-size/MorningMC/.flakes?style=for-the-badge)
![Nix Flake](https://img.shields.io/badge/Nix_Flake-5e81ac?logo=nixos&logoColor=d8dee9&style=for-the-badge)

These are the Nix flakes that I use to build my NixOS system, packages, etc. The flakes are aimed to arrange in a clear and maintainable
way. As this repository is licensed under [MIT](LICENSE.txt), you might refer to or use these flakes, but some flakes might **not** fit
everyone as these are mainly for my personal use.

Sometimes a `README.md` file might be present in the root of a specific flake for further explanation of that flake. See
[README in `nixos` flake](nixos/README.md) as an example.

## Usage

Each folder under this repository is a [Nix flake](https://wiki.nixos.org/wiki/Flakes). To use any flake in this repository, you should
have [Nix (or NixOS)](https://nixos.org) installed on your computer and have `nix-command` and `flakes` experimental features enabled.
See [here](https://wiki.nixos.org/wiki/Flakes#Setup) for details. In any other `README.md` file in this repository, these prerequisites
will not be explained twice.

Depending on the content of the flake and your situation, there are several ways for you to use a flake:

### Use as a flake input

If you want to reuse a Nix expression, a package, or a module in another flake, you can import a specific flake using

```nix
# Replace ${flake} to the name of the specific flake
inputs.${flake}.url = "github:MorningMC/.flakes?dir=${flake}";
```

in your `flake.nix` file, or pin to a specific commit using

```nix
# Replace ${flake} and ${commit} to the name of the specific flake and the full hash of the commit
inputs.${flake}.url = "github:MorningMC/.flakes/${commit}?dir=${flake}";
```

. Lock the commit in `flake.lock` is favorable as well. Additionally, if the flake has a `nixpkgs` input, it is recommended to add

```nix
# Replace ${flake} to the name of the specific flake
inputs.${flake}.inputs.nixpkgs.follows = "nixpkgs";
```

in your `flake.nix` file to achieve a consistent Nixpkgs channel and avoid duplication. Without this line, the flake should continue
to function.

### Use with `nix` commands

If the flake contains a package, an application, or a shell environment, you can use it directly with
[`nix` commands](https://nix.dev/manual/nix/2.28/command-ref/new-cli/nix.html).

#### Build a package

If the flake declares a derivation output at `packages.${system}.${name}` or `legacyPackages.${system}.${name}`, where `${system}` is
the system architecture of your machine and `${name}` can be any string representing the name of the package, you can execute

```bash
# Replace $flake and $name with the name of the specific flake and the name of the package
nix build "github:MorningMC/.flakes?dir=$flake#$name"
```

to build the derivation, where `packages.${system}.${name}` and `legacyPackages.${system}.${name}` will be searched in order.

If `${name}` is `default`, you can omit the `#$name` part in the command. After building, Nix will generate a `result` symbolic link
under your current working directory, which point to a folder or a file in the Nix store, containing the build result.

#### Run an application

If the flake declares an [app definition](https://nix.dev/manual/nix/2.28/command-ref/new-cli/nix3-run#apps) output at
`apps.${system}.${name}`, or an derivation output containing any executable at `packages.${system}.${name}` or
`legacyPackages.${system}.${name}`, where `${system}` is the system architecture of your machine and `${name}` can be any string
representing the name of the package or application, you can execute

```bash
# Replace $flake and $name with the name of the specific flake and the name of the package or application and "$@" with the arguments
# passed to the application or executable
nix run "github:MorningMC/.flakes?dir=$flake#$name" -- "$@"
```

to run the executable in the package or application directly. `apps.${system}.${name}`, `packages.${system}.${name}`, and
`legacyPackages.${system}.${name}` will be searched in order.

If `${name}` is `default`, you can omit the `#$name` part in the command. If there are no arguments passed to the executable, `-- "$@"`
part of the command can be omitted as well.

#### Enter a temporary shell environment

Like `nix build`, if the flake declares a derivation output at `packages.${system}.${name}` or `legacyPackages.${system}.${name}`,
where `${system}` is the system architecture of your machine and `${name}` can be any string representing the name of the package, you
can execute

```bash
# Replace $flake and $name with the name of the specific flake and the name of the package
nix shell "github:MorningMC/.flakes?dir=$flake#$name"

```

to drop into a temporary shell environment, where `packages.${system}.${name}` and `legacyPackages.${system}.${name}` will be searched
in order.

If `${name}` is `default`, you can omit the `#$name` part in the command. Once inside this shell, the binary executables bundled within
the derivation are temporarily exposed to your `PATH` environment variable, allowing you to execute them instantly. You can type `exit`
or close your terminal session to exit the shell at anytime you want.

#### Pin to a specific commit

Similar to using a flake as a input of another flake, in all the above cases, you can pin to a specific commit by appending a `/`
character followed by the full hash of the commit after `github:MorningMC/.flakes`. For example, to build the package defined at
`packages.x86_64-linux.default` in flake `minecraft-ttf` pinned to commit `896308bbd43e71793cb711f65190961897e517d4`, execute

```bash
nix build github:MorningMC/.flakes/896308bbd43e71793cb711f65190961897e517d4?dir=minecraft-ttf
```

on a machine with `x86_64-linux` architecture.

#### Clone the repository to local

As a alternative, you can clone the entire repository to local by executing

```bash
git clone https://github.com/MorningMC/.flakes.git
# Or if you have configured SSH
#git clone git@github.com:MorningMC/.flakes.git
```

, and change your working directory to your desired flake. For example, to enter a shell environment with all executables in derivation
defined at `packages.x86_64-linux.default` in flake `quickshell` exposed to `PATH` environment variable, run

```bash
# Assume you have already cloned the repository to .flakes
cd .flakes/quickshell

nix shell
# By default nix commands will search the flake in the current directory, so this is a shorthand of
#nix shell ".#default"
# where `.` and `#default` is omitted
```

in your terminal.

For more details on `nix` commands and their expected outputs in flakes, visit [here](https://wiki.nixos.org/wiki/Flakes#Output_schema).

### Using flakes with dependencies

You are welcomed to fork or clone this repository, but be aware that some flakes in this repository depends on each other. It is
perfectly fine to just call the remote flake by using `github:MorningMC/.flakes?dir=${flake}`, where Nix implicitly fetches the flakes
to local Nix store and resolves dependencies.

If you insist to use a single flake locally, make sure it has no dependency or it is included in a Git repository **alongside with its
dependencies**, as Nix will treat a Git repository as a whole during evaluation. If the repository is absent, Nix will only copy that
single flake to Nix store and fail during evaluation as the flake cannot find its dependency using relative path.
