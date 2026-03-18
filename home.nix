{ config, pkgs, ... }:

let
  user = "polvos-magicos";
  homeDir = "/home/${user}";
in
{
  home.username = user;
  home.homeDirectory = homeDir;

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    bat
    curl
    btop
  ];
}
