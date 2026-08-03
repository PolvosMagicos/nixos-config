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
    buildah
    kubectl
    postgresql
    minikube

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

    # iot tools
    platformio
    cargo-generate
    espflash
    ldproxy

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
    mpv
    vlc
    jetbrains.datagrip
    postman
    tidal-hifi

    # Media / terminal apps
    cava
    rmpc
    yaziPkg
    sshx

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

    # Lsp's
    (pkgs.lib.hiPrio pkgs.rust-analyzer)

    # Neovim
    tree-sitter

    # Games
    prismlauncher

    # Other
    cloudflared
    bubblewrap
    ocrmypdf
    easyeffects
    libnotify

    # Utils
    qbittorrent
    normcap
  ];
}
