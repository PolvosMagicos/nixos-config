{ pkgs, inputs, system, yaziPkg, ... }:

let
  codexVersion = "0.162.1";
  codex = pkgs.runCommand "codex-${codexVersion}" {
    nativeBuildInputs = with pkgs; [ gnutar gzip installShellFiles ];
  } ''
    mkdir -p "$out"
    tar -xzf ${pkgs.fetchurl {
      url = "https://github.com/openai/codex/releases/download/rust-v${codexVersion}/codex-npm-linux-x64-${codexVersion}.tgz";
      hash = "sha256-dBdxFni0ZO7nBmQSbjnoi7PITCko2g5x8UtW4E/1wJ8=";
    }} --strip-components=3 -C "$out"
    installShellCompletion --cmd codex \
      --bash <("$out/bin/codex" completion bash) \
      --fish <("$out/bin/codex" completion fish) \
      --zsh <("$out/bin/codex" completion zsh)
  '';
in
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
    sone
    teams-for-linux

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
    (inputs.quickshell.packages.${system}.default.withModules [
      inputs.qml-niri.packages.${system}.default
      kdePackages.qtmultimedia
    ])

    # AI / tools
    codex

    # Lsp's
    (pkgs.lib.hiPrio pkgs.rust-analyzer)

    # Neovim
    tree-sitter

    # Games
    prismlauncher
    inputs.osu-lazer.packages.${system}.osu-lazer-bin

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
