{ config, pkgs, ... }:

let
  user = "polvos-magicos";
  homeDir = "/home/${user}";
  dotfiles = "${homeDir}/dotfiles/.config";

  configs = [ "cava" "kitty" "mpd" "nushell" "nvim" "rmpc" "yazi" "niri" ];

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

  home.packages = with pkgs; [
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
    discord
    spotify
    pciutils
    mesa-demos
    vulkan-tools
  ];

  xdg.configFile = builtins.listToAttrs (map mkCfg configs);
}
