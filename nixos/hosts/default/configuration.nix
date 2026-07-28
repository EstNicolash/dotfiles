{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./host-specific.nix
    ../../system/core.nix
    ../../system/wm-runtime.nix
    ../../system/games.nix
    ../../system/theme.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.cachyosKernels."linuxPackages-cachyos-latest-lto-x86_64-v3";

  boot.kernel.sysctl = {
    "fs.inotify.max_user_watches" = 524288;
  };
  boot.kernelModules = [
    "fuse"
    "v4l2loopback"
  ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
  '';

  services.scx.enable = true;

  nix.settings.auto-optimise-store = true;
  nix.settings.max-jobs = 4;
  nix.settings.cores = 6;
  nix.gc = {
    automatic = true;
    persistent = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };

  networking.networkmanager.enable = true;
  services.resolved.enable = true;
  services.udisks2.enable = true;
  services.gvfs.enable = true;
  services.flatpak.enable = true;
  services.dbus.enable = true;
  security.polkit.enable = true;
  nixpkgs.config.allowUnfree = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };
  services.accounts-daemon.enable = true;

  programs.zsh.enable = true;
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    nushell
    wget
    home-manager
    distrobox
    distroshelf
    libva-utils
    v4l-utils
    cachix
    xcb-util-cursor
    libmtp
    gphoto2
    kdePackages.kio-extras
    kdePackages.plasma-workspace
    zenity
  ];

  environment.etc."xdg/menus/plasma-applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  system.stateVersion = "25.05";
}
