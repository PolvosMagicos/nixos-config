{ config, pkgs, inputs, ... }:

let
  user = "polvos-magicos";
  homeDir = "/home/${user}";
  dotfiles = "${homeDir}/dotfiles/.config";
  system = pkgs.stdenv.hostPlatform.system;

  yaziPkg = inputs.yazi.packages.${system}.default.override {
    _7zz = pkgs._7zz-rar;
  };
in
{
  imports = [
    ./packages.nix
    ./xdg.nix
    ./programs/git.nix
    ./programs/vesktop.nix
  ];

  _module.args = {
    inherit user homeDir dotfiles system yaziPkg;
  };

  home.username = user;
  home.homeDirectory = homeDir;

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;
}
