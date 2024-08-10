# Installation

## Pre-requisition

1. NixOS installed and running
2. Flakes enabled

> [!warning] Note: Don't copy the nixos directory as the configs are suited for my personal computer especially the `hardware.nix` file.

- `git clone https://github.com/yukendhiran/nixOS-dots.git`
- `cd nixOS-dots`
- `cp -r ags $HOME/.config`
- `cp -r desk hyprland packages terminal utils *.nix $HOME/.config/home-manager`

In the `flake.nix` and `home.nix` change my username to the one you use on your computer, double check to avoid any errors before running the below commands.

- `sudo nixos-rebuild switch --flake .#yourUsername` to apply system configs.
- `home-manager switch --flake .#yourUsername@hostname` to apply home-manager configs.

# Acknowledgements

Thanks to Mbhon1, I used Mbhon1's config as my base and started customizing it

- [Mbhon1](https://github.com/Mbhon1)
