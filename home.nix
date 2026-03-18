{ config, pkgs, ... }:

let
  user = "polvos-magicos";
  homeDir = "/home/${user}";
  dotfiles = "${homeDir}/dotfiles/.config";

  configs = [ "cava" "kitty" "mpd" "nushell" "nvim" "rmpc" "yazi" ];

  mkCfg = name: {
    name = name;
    value.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
  };
in
{
  home.username = user;
  home.homeDirectory = homeDir;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "Polvos Magicos";
    userEmail = "73202603+PolvosMagicos@users.noreply.github.com";
  };

  home.packages = with pkgs; [
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
    steam
  ];

  xdg.configFile = builtins.listToAttrs (map mkCfg configs);
}
