# ==============================================================================
# Host System Configuration (nixos/hosts/default/configuration.nix)
#
# Entry point for the NixOS system configuration on this host.
# Aggregates hardware-specific definitions and shared system modules,
# configures the bootloader, CachyOS LTO kernel, kernel modules, scheduler,
# and essential system-wide packages.
# ==============================================================================
{ config, pkgs, ... }:

{
  # ----------------------------------------------------------------------------
  # Module Imports
  # ----------------------------------------------------------------------------
  imports = [
    # Host-specific hardware & device definitions
    ./hardware-configuration.nix
    ./host-specific.nix

    # Shared system-wide modules
    ../../system/core.nix
    ../../system/wm-runtime.nix
    ../../system/games.nix
    ../../system/theme.nix
  ];

  # ----------------------------------------------------------------------------
  # Bootloader & Kernel
  # ----------------------------------------------------------------------------
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        # Cap boot entries to prevent filling up the EFI system partition
        configurationLimit = 10;
      };
      efi.canTouchEfiVariables = true;
    };

    # CachyOS kernel compiled with LTO and x86_64-v3 optimizations (Zen 3)
    kernelPackages = pkgs.cachyosKernels."linuxPackages-cachyos-latest-lto-x86_64-v3";

    # Raise file watcher limit for IDEs, compilers, and language servers
    kernel.sysctl = {
      "fs.inotify.max_user_watches" = 524288;
    };

    # Virtual webcam kernel module (used by OBS Studio)
    kernelModules = [ "v4l2loopback" ];
    extraModulePackages = with config.boot.kernelPackages; [ v4l2loopback ];
    extraModprobeConfig = ''
      options v4l2loopback devices=1 video_nr=1 card_label="OBS Cam" exclusive_caps=1
    '';
  };

  # Enable sched_ext BPF CPU scheduler loader (pairs with CachyOS kernel)
  services.scx-loader = {
    enable = true;
    config = {
      default_sched = "scx_lavd";
      default_mode = "Auto";
    };
  };

  # ----------------------------------------------------------------------------
  # Essential System-Wide Packages
  # ----------------------------------------------------------------------------
  # Keep global packages minimal; user CLI/GUI apps belong in Home Manager.
  environment.systemPackages = with pkgs; [
    # Emergency root/TTY editor fallback
    vim

    # Hardware, video acceleration, and camera/MTP device utilities
    libva-utils
    v4l-utils
    libmtp
    gphoto2
  ];

  # ----------------------------------------------------------------------------
  # NixOS State Version
  # ----------------------------------------------------------------------------
  # Do not change unless performing a full manual state migration.
  system.stateVersion = "25.05";
}
