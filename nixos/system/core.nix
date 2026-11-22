# ==============================================================================
# Core System Configuration (nixos/system/core.nix)
#
# Defines foundational NixOS settings shared across hosts:
# Nix daemon & garbage collection, nixpkgs overlays/overrides, networking,
# storage services, virtualization/containers, localization, and user accounts.
# ==============================================================================
{ inputs, pkgs, ... }:

{
  # ----------------------------------------------------------------------------
  # Nix Daemon, Store & Garbage Collection
  # ----------------------------------------------------------------------------
  nix = {
    gc = {
      automatic = true;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };

    settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      trusted-users = [
        "root"
        "@wheel"
      ];

      max-jobs = 2;
      cores = 8;

      # Binary caches
      substituters = [ "https://niri.cachix.org" "https://cache.lantian.pub/lantian" ];
      trusted-public-keys = [
        "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
        "lantian:WVGO7vsRMSEN+h7Lp7kv6SAmrkEXgUGbbXm7jMDjBuQ="
      ];
    };
  };

  # ----------------------------------------------------------------------------
  # Nixpkgs Configuration & Overlays
  # ----------------------------------------------------------------------------
  nixpkgs = {
    config.allowUnfree = true;

    overlays = [
      inputs.niri.overlays.niri
      inputs.nix-cachyos-kernel.overlays.pinned

      # Package-specific build workarounds
      #(final: prev: {
        # Skip slow/flaky OpenLDAP test suite on non-i686 builds
        #openldap = prev.openldap.overrideAttrs (old: {
          #doCheck = !prev.stdenv.hostPlatform.isi686;
          #});

        # Restrict outputs to prevent broken/missing secondary outputs in khal
        #khal = prev.khal.overrideAttrs (old: {
         # outputs = [ "out" ];
          #  });
      #})
    ];
  };

  # ----------------------------------------------------------------------------
  # Networking & Storage Services
  # ----------------------------------------------------------------------------
  networking.networkmanager.enable = true;
  services.resolved.enable = true;

  # Automounting & virtual filesystem support (used by Cosmic Files & GVFS)
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Periodic TRIM for NVMe SSD longevity
  services.fstrim.enable = true;



  boot.tmp = {
    useTmpfs = true;
    tmpfsSize = "50%";
  };

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 25;
  };
  # ----------------------------------------------------------------------------
  # Virtualization, Containers & Network Analysis
  # ----------------------------------------------------------------------------
  virtualisation = {
    libvirtd.enable = true;
    podman = {
      enable = true;
      dockerCompat = true;
      autoPrune = {
          enable = true;
          dates = "weekly";
          flags = [ "--all" ];
      };
    };
  };

  programs = {
    virt-manager.enable = true;
    wireshark.enable = true;
  };

  # ----------------------------------------------------------------------------
  # Timezone, Keyboard & Localization
  # ----------------------------------------------------------------------------
  time.timeZone = "America/Sao_Paulo";

  console.keyMap = "br-abnt2";
  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_ADDRESS = "pt_BR.UTF-8";
      LC_IDENTIFICATION = "pt_BR.UTF-8";
      LC_MEASUREMENT = "pt_BR.UTF-8";
      LC_MONETARY = "pt_BR.UTF-8";
      LC_NAME = "pt_BR.UTF-8";
      LC_NUMERIC = "pt_BR.UTF-8";
      LC_PAPER = "pt_BR.UTF-8";
      LC_TELEPHONE = "pt_BR.UTF-8";
      LC_TIME = "pt_BR.UTF-8";
    };
  };

  # ----------------------------------------------------------------------------
  # Primary User Account
  # ----------------------------------------------------------------------------
  # Keep login shell POSIX-compliant (bash default); launch Nushell via terminal
  users.users.nan = {
    isNormalUser = true;
    description = "Nicolas A. N. S.";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "gamemode"
      "adbusers"
      "wireshark"
      "libvirtd"
    ];
  };
}
