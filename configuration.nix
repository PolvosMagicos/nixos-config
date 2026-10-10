# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./gpu-apps.nix
    ];

  # Previous systemd-boot bootloader, replaced for limine for dual booting windows
  # boot.loader.systemd-boot.enable = false;
  boot.loader.limine = {
  enable = true;

  secureBoot.enable = true;

  efiInstallAsRemovable = true;

  maxGenerations = 5;
    extraEntries = "
      /Windows 11
        protocol: efi
	path: guid(35524996-ec85-4d2e-bcec-a14b14299c37):/EFI/Microsoft/Boot/bootmgfw.efi
    ";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  # Niri
  programs.niri.enable = true;

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;

    wlr = {
      enable = true;
      settings = {
        screencast = {
          max_fps = 60;
          force_mod_linear = true;
        };
      };
    };

    extraPortals = with pkgs; [
      xdg-desktop-portal-wlr
      xdg-desktop-portal-gtk
    ];

    config = {
      niri = {
        default = lib.mkForce [ "gtk" ];
        "org.freedesktop.impl.portal.ScreenCast" = lib.mkForce [ "wlr" ];
        "org.freedesktop.impl.portal.Screenshot" = lib.mkForce [ "wlr" ];
        "org.freedesktop.impl.portal.FileChooser" = lib.mkForce [ "gtk" ];
      };
    };
  };
  security.polkit.enable = true;

  # Use latest kernel.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  # Initialize nushell after bash
  environment.shells = with pkgs; [
    pkgs.bashInteractive
    pkgs.nushell
  ];

  programs.bash.interactiveShellInit = ''
    if [[ -z "$DISPLAY" && -z "$WAYLAND_DISPLAY" && "$XDG_VTNR" = "1" && "$TERM" != "dumb" && -z "$BASH_EXECUTION_STRING" ]]; then
      exec niri-session
    fi
  '';

  networking.hostName = "nixos-btw"; # Define your hostname.

  # Configure network connections interactively with nmcli or nmtui.
  networking.networkmanager.enable = true;

  # TCP ports
  networking.firewall.allowedTCPPorts = [
    1883 # MQTT broker, needed by ESP32
    1880 # Node-RED, only if accessed from other devices
    3000 # Grafana, only if accessed from other devices
    8086 # InfluxDB, usually not needed externally
  ];

  # Enable nix flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # Keep Codex's protected socket on a filesystem whose mount ID matches stat.
  fileSystems."/tmp/codex-daemon-1000" = {
    device = "tmpfs";
    fsType = "tmpfs";
    options = [ "uid=1000" "mode=0700" "size=16M" "nosuid" "nodev" "noexec" "nofail" ];
  };

  # Upower
  services.upower.enable = true;

  # Set your time zone.
  time.timeZone = "America/Lima";

  # udisks2 service for yazi mount
  services.udisks2.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Enable the X11 windowing system.
  # services.xserver.enable = true;

  # Configure keymap in X11
  # services.xserver.xkb.layout = "us";
  # services.xserver.xkb.options = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # services.pulseaudio.enable = true;
  # OR
  # services.pipewire = {
  #   enable = true;
  #   pulse.enable = true;
  # };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;

  # Android
  nixpkgs.config.android_sdk.accept_license = true;
  programs.nix-ld.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.polvos-magicos = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "kvm" "dialout" ]; # Enable ‘sudo’ for the user.
    shell = pkgs.bashInteractive;
    packages = with pkgs; [
      tree
    ];
  };

  programs.firefox.enable = true;
  programs.steam.enable = true;
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  # You can use https://search.nixos.org/ to find more packages (and options).
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    
    # Essentials (for me)
    neovim
    sbctl
    git
    kitty
    nushell

    # Zen Browser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Niri dependencies
    alacritty
    xwayland-satellite
    waybar
    fuzzel
    wl-clipboard
    grim
    slurp

    # Android
    android-studio
    android-tools
    javaPackages.compiler.openjdk17
  ];

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts
    noto-fonts-color-emoji
  ];

  # qmk rules
  services.udev.packages = with pkgs; [
    qmk-udev-rules
  ];

  services.udev.extraRules = ''
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{serial}=="*vial:f64c2b3c*", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';

  # Nvidia config
  hardware.graphics.enable = true;

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];
  
  hardware.nvidia = {
    # shortcut: driver updates are manual, use nvidiaPackages.latest once 26.05 supports Linux 7.2.
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "615.71.09";
      sha256_64bit = "sha256-zc7tIrvrYSSNGm3qvCWWZz46ZQFpjucayNL9wo87cP4=";
      sha256_aarch64 = "sha256-IbekQhE7cFfmnPZaLY9NDYcF7CoNZ+2Qb7sRd4EOgWM=";
      openSha256 = "sha256-3gByMYIwFzRaLdDG+roCEOuKRRJDrljG9AlLnRZTirM=";
      settingsSha256 = "sha256-LK1LU8mDkM/XVRKPBtuOZh9nIP/lGFLAJnmasEX8jhg=";
      persistencedSha256 = "sha256-qPRb+3d88+2RcpUkoBTbjIaImnQ+jX+/6p1vXcJ5geE=";
    };

    modesetting.enable = true;
    powerManagement.enable = true;

    open = true;

    nvidiaSettings = true;

    prime = {
      amdgpuBusId = "PCI:101@0:0:0";
      nvidiaBusId = "PCI:1@0:0:0";

      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };
  };

  # Zram swap
  zramSwap = {
    enable = true;
    memoryPercent = 50;
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}
