# ==============================================================================
# Host-Specific Hardware Configuration (nixos/hosts/default/host-specific.nix)
#
# Defines machine-specific settings tied to physical hardware on this host:
# disk encryption (LUKS), hostname, AMD GPU drivers, graphics acceleration,
# and Bluetooth support.
# ==============================================================================
{ pkgs, ... }:

{
  # ----------------------------------------------------------------------------
  # Host Identity & Storage
  # ----------------------------------------------------------------------------
  networking.hostName = "nixos";

  boot.initrd.luks.devices."luks-153a094a-1996-451c-91be-a43209c690e4" = {
    device = "/dev/disk/by-uuid/153a094a-1996-451c-91be-a43209c690e4";
    # Enable TRIM passthrough for NVMe SSD health and write performance
    allowDiscards = true;
  };

  # ----------------------------------------------------------------------------
  # Graphics & Hardware Acceleration (AMD GPU)
  # ----------------------------------------------------------------------------
  services.xserver.videoDrivers = [ "amdgpu" ];

  hardware.graphics = {
    enable = true;
    # Required for 32-bit applications (Steam, Proton, Wine, umu-run)
    enable32Bit = true;
    # Mesa and vulkan-loader are included automatically; only add extra ICDs
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  # ----------------------------------------------------------------------------
  # Peripherals
  # ----------------------------------------------------------------------------
  hardware.bluetooth.enable = true;
}
