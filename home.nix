{ config, pkgs, inputs, ... }:

let
  user = "polvos-magicos";
  homeDir = "/home/${user}";
  dotfiles = "${homeDir}/dotfiles/.config";

  configs = [ "cava" "kitty" "mpd" "nushell" "nvim" "rmpc" "yazi" "niri" "quickshell" ];

  mkCfg = name: {
    name = name;
    value.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
  };
in
{
  home.username = user;
  home.homeDirectory = homeDir;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    settings.user.name = "Polvos Magicos";
    settings.user.email = "73202603+PolvosMagicos@users.noreply.github.com";
  };

  programs.vesktop = {
    enable = true;

    vencord.settings = {
      autoUpdate = true;
      autoUpdateNotification = true;
      notifyAboutUpdates = true;
    };
  };

  home.packages = with pkgs; [
    papirus-icon-theme
    nodejs_24
    watchman
    scrcpy
    gcc
    ripgrep
    gnumake
    tailwindcss-language-server
    bat
    curl
    btop
    fnm
    fzf
    lazygit
    zoxide
    eza
    yazi
    cava
    rmpc
    spotify
    pciutils
    mesa-demos
    vulkan-tools
    nvtopPackages.full
    vial
    inputs.qml-niri.packages.${pkgs.stdenv.hostPlatform.system}.quickshell
    kdePackages.qtdeclarative
  ];

  xdg.configFile = builtins.listToAttrs (map mkCfg configs);
}
