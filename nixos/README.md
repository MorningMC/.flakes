# NixOS System Flake

This flake configures my system, which is available at `github:MorningMC/.flakes?dir=nixos`. It is **not** recommened to use this flake
directly, but you are welcome to refer to or study this flake. Also acknowledging [@frsFallingSand](https://github.com/frsFallingSand)
here as this flake hugely refers to his [nix-dots](https://github.com/frsFallingSand/nix-dots) and his explanation to me.

## Structure

This flake has a clean and maintainable structure heavily inspired to [this repo](https://github.com/MCB-SMART-BOY/nixos-config). It
is organized in the following way:

- `modules`: This folder contains a series of `*.nix` files, including a `default.nix` as entry module, which represents options related
  to the system itself or Nix store, for example, Nvidia drivers, locale, Nix experimental features or Nix garbage cleaner options.
  Personal daily used software packages should **never** appear in this folder. Instead, put these packages in `home/<username>`.
- `hosts`: This folder contains a series of folder, each represents a specific machine, named as the machine's hostname. Each of the
  subfolders contains a series of `*.nix` files, including a `default.nix` as entry module, which represents options differs on each
  machine or dependent on the hardware used, for example, disk partition layout, swap device, or boot options.
- `home`: This folder contains a series of folder, each represents a specific user, named as the user's assigned username. Each of the
  subfolders contains a series of `*.nix` files, including a `default.nix` as entry module, which represents options related to a user,
  including its used spftware packages, desktops, or Home Manager configurations. In most cases, if your desired changes does not belong
  to any of the category above, you should perform the change in your respective folder in `home`.

Note that this flake is **not** capable to build in traditional `/etc/nixos` way since it lacks required `configuration.nix`. The entry
module in each folder is managed and loaded by `flake.nix`.
