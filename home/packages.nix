{ pkgs, inputs, system, yaziPkg, ... }:

{
  home.packages = with pkgs; [
    # Theme / UI
    papirus-icon-theme
    kdePackages.qtdeclarative

    # CLI basics
    bat
    curl
    dig
    ripgrep
    fzf
    eza
    zoxide
    btop
    lazygit

    # Shell / dev tools
    fnm
    nodejs_24
    bun
    gcc
    gnumake
    pkg-config
    openssl
    rustup
    python314

    # React Native / Android helpers
    watchman
    scrcpy

    # Containers
    podman
    podman-compose

    # Desktop apps
    vesktop
    spotify
    keepassxc
    obs-studio
    insomnia

    # Media / terminal apps
    cava
    rmpc
    yaziPkg

    # Hardware / GPU tools
    pciutils
    mesa-demos
    vulkan-tools
    nvtopPackages.full
    vial
    lshw

    # Niri / Quickshell
    inputs.qml-niri.packages.${system}.quickshell

    # AI / tools
    inputs.codex-cli-nix.packages.${system}.default

    # Other
    cloudflared
    bubblewrap
    ocrmypdf
  ];
}
