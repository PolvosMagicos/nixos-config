# nixos-config

My personal NixOS configuration for my Lenovo Legion 5 setup, managed with flakes and Home Manager.

This repository contains my system configuration, user packages, desktop environment setup, development tools, and Home Manager modules for my daily NixOS machine.

## Overview

This config is built around:

- NixOS with flakes
- Home Manager as a NixOS module
- Niri as the Wayland compositor
- Limine bootloader with Secure Boot enabled
- NVIDIA + AMD hybrid graphics with PRIME offload
- Android / React Native development tooling
- Rust, Node, Bun, Python and container development tools
- Quickshell custom bar
- Yazi, Vesktop, Zen Browser, Spotify, OBS and other desktop apps
- Selected user configuration linked into `~/.config`

## Host

Current flake host:

```bash
nixos-btw
```

Build target:

```bash
sudo nixos-rebuild switch --flake .#nixos-btw
```

## Repository structure

```txt
.
├── flake.nix
├── flake.lock
├── configuration.nix
├── hardware-configuration.nix
└── home
    ├── default.nix
    ├── packages.nix
    ├── xdg.nix
    └── programs
        ├── git.nix
        └── vesktop.nix
```

## Main features

### System

- NixOS 25.11
- Latest Linux kernel
- Flakes enabled
- NetworkManager
- Timezone: `America/Lima`
- `nix-ld` enabled for compatibility with external binaries
- UPower enabled
- udisks2 enabled for removable drive support
- QMK/Vial udev rules for keyboard configuration

### Bootloader

This configuration uses Limine instead of systemd-boot.

Limine is configured with:

- Secure Boot support
- Maximum 5 generations
- Manual Windows 11 EFI entry for dual boot

### Desktop

The main graphical session is based on:

- Niri
- Wayland
- XDG portals
- Fuzzel
- Mako
- Quickshell custom bar
- Xwayland Satellite
- Grim + Slurp for screenshots
- wl-clipboard

The system starts `niri-session` automatically from TTY1 when logging in through the shell.

### Graphics

Hybrid GPU setup:

- AMD iGPU
- NVIDIA dGPU
- NVIDIA open kernel module enabled
- PRIME offload enabled
- `nvidia-offload` command enabled

Useful example:

```bash
nvidia-offload <command>
```

For Steam games, a launch option like this can be useful:

```bash
__NV_PRIME_RENDER_OFFLOAD=1 __GLX_VENDOR_LIBRARY_NAME=nvidia __VK_LAYER_NV_optimus=NVIDIA_only %command%
```

### Home Manager

Home Manager is integrated directly into the NixOS flake.

The current user is:

```bash
polvos-magicos
```

Home Manager modules are loaded from:

```txt
home/
```

No separate `home-manager switch` is required when rebuilding the full system with:

```bash
sudo nixos-rebuild switch --flake .#nixos-btw
```

### External config links

Some configuration directories are linked into `~/.config` using `mkOutOfStoreSymlink`.

Expected local path:

```bash
~/dotfiles/.config
```

Source repository:

```txt
https://github.com/PolvosMagicos/dotfiles
```

Clone it before rebuilding if the path does not exist:

```bash
git clone https://github.com/PolvosMagicos/dotfiles.git ~/dotfiles
```

Linked config directories:

```txt
cava
containers
kitty
mpd
nushell
nvim
rmpc
yazi
niri
quickshell
```

## Installed tools

### CLI and development

- git
- neovim
- bat
- curl
- dig
- ripgrep
- fzf
- eza
- zoxide
- btop
- lazygit
- gcc
- gnumake
- pkg-config
- openssl
- rustup
- Python 3.14
- Node.js 24
- Bun
- fnm

### Android / React Native

- Android Studio
- Android tools
- OpenJDK 17
- watchman
- scrcpy

### Containers

- podman
- podman-compose

### Desktop apps

- Zen Browser
- Vesktop
- Spotify
- KeePassXC
- OBS Studio
- Insomnia

### Terminal / media

- Kitty
- Cava
- rmpc
- Yazi

### Hardware / GPU

- pciutils
- mesa-demos
- vulkan-tools
- nvtop
- Vial

### AI / productivity

- Codex CLI
- cloudflared
- ocrmypdf

## Installation

> This repository is personal and hardware-specific. Do not use it blindly on another machine without reviewing `hardware-configuration.nix`, disk UUIDs, GPU settings, bootloader entries, username, and external config paths.

Clone the NixOS configuration:

```bash
git clone https://github.com/PolvosMagicos/nixos-config.git ~/nixos-config
cd ~/nixos-config
```

Review the configuration:

```bash
nvim flake.nix
nvim configuration.nix
nvim home/default.nix
```

Test the build:

```bash
sudo nixos-rebuild test --flake .#nixos-btw
```

Apply the configuration:

```bash
sudo nixos-rebuild switch --flake .#nixos-btw
```

Reboot if needed:

```bash
reboot
```

## Updating

Update flake inputs:

```bash
nix flake update
```

Rebuild:

```bash
sudo nixos-rebuild switch --flake .#nixos-btw
```

## Useful commands

Test config without switching permanently:

```bash
sudo nixos-rebuild test --flake .#nixos-btw
```

Switch to the new config:

```bash
sudo nixos-rebuild switch --flake .#nixos-btw
```

Build without switching:

```bash
sudo nixos-rebuild build --flake .#nixos-btw
```

Clean old generations:

```bash
sudo nix-collect-garbage -d
```

Optimize the Nix store:

```bash
nix-store --optimise
```

## Notes

This configuration is designed for my personal laptop and workflow. It includes hardware-specific settings such as:

- Btrfs root filesystem UUID
- EFI boot partition UUID
- Limine Windows boot entry
- AMD + NVIDIA PRIME bus IDs
- User-specific Home Manager path
- External config links under `~/dotfiles/.config`

Before adapting this config to another machine, regenerate your own hardware config:

```bash
sudo nixos-generate-config --show-hardware-config
```

Then replace or adjust `hardware-configuration.nix`.

## Credits

Personal NixOS configuration by [PolvosMagicos](https://github.com/PolvosMagicos).
