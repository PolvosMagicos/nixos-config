{ config, dotfiles, ... }:

let
  configs = [
    "cava"
    "containers"
    "fuzzel"
    "kitty"
    "mpd"
    "nushell"
    "nvim"
    "rmpc"
    "yazi"
    "niri"
    "quickshell"
  ];

  mkCfg = name: {
    name = name;
    value.source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/${name}";
  };
in
{
  xdg.configFile = builtins.listToAttrs (map mkCfg configs);
}
