{ pkgs, ... }:

let
  autoGpuRun = pkgs.writeShellScriptBin "auto-gpu-run" ''
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "$#" -lt 1 ]; then
      echo "Usage: auto-gpu-run <command> [args...]"
      exit 1
    fi

    app="$1"
    shift || true

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
in
{
  environment.systemPackages = [
    autoGpuRun
    zenAutoGpuDesktop
    vesktopAutoGpuDesktop
  ];
}
