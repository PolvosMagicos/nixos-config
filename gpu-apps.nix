{ pkgs, ... }:

let
  autoGpuRun = pkgs.writeShellScriptBin "auto-gpu-run" ''
    set -euo pipefail

    if [ "$#" -lt 1 ]; then
      echo "Usage: auto-gpu-run <command> [args...]"
      exit 1
    fi

    app="$1"
    shift

    on_ac=0

    for supply in /sys/class/power_supply/*; do
      if [ -f "$supply/type" ] && [ -f "$supply/online" ]; then
        type="$(cat "$supply/type")"
        online="$(cat "$supply/online")"

        if [ "$type" = "Mains" ] && [ "$online" = "1" ]; then
          on_ac=1
          break
        fi
      fi
    done

    if [ "$on_ac" = "1" ]; then
      echo "AC connected: launching with NVIDIA offload: $app"
      exec nvidia-offload "$app" "$@"
    else
      echo "On battery: launching normally: $app"
      exec "$app" "$@"
    fi
  '';

  zenAutoGpuDesktop = pkgs.makeDesktopItem {
    name = "zen-auto-gpu";
    desktopName = "Zen Browser Auto GPU";
    genericName = "Web Browser";
    comment = "Launch Zen with NVIDIA offload only when plugged in";
    exec = "${autoGpuRun}/bin/auto-gpu-run zen %U";
    icon = "zen";
    terminal = false;
    categories = [ "Network" "WebBrowser" ];
  };

  vesktopAutoGpuDesktop = pkgs.makeDesktopItem {
    name = "vesktop-auto-gpu";
    desktopName = "Vesktop Auto GPU";
    genericName = "Chat";
    comment = "Launch Vesktop with NVIDIA offload only when plugged in";
    exec = "${autoGpuRun}/bin/auto-gpu-run vesktop";
    icon = "vesktop";
    terminal = false;
    categories = [ "Network" "Chat" ];
  };

  tidalAutoGpuDesktop = pkgs.makeDesktopItem {
    name = "tidal-hifi-auto-gpu";
    desktopName = "TIDAL Hi-Fi Auto GPU";
    genericName = "Music Player";
    comment = "Launch TIDAL with NVIDIA offload only when plugged in";

    exec = "${autoGpuRun}/bin/auto-gpu-run ${pkgs.tidal-hifi}/bin/tidal-hifi --disable-dev-shm-usage --ozone-platform=x11 %U";

    icon = "tidal-hifi";
    terminal = false;
    categories = [ "AudioVideo" "Audio" "Music" "Player" ];
    mimeTypes = [ "x-scheme-handler/tidal" ];
  };
in
{
  environment.systemPackages = [
    autoGpuRun

    zenAutoGpuDesktop
    vesktopAutoGpuDesktop
    tidalAutoGpuDesktop
  ];
}
