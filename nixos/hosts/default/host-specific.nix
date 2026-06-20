{ config, pkgs, ... }:

{
  boot.initrd.luks.devices."luks-153a094a-1996-451c-91be-a43209c690e4".device =
    "/dev/disk/by-uuid/153a094a-1996-451c-91be-a43209c690e4";

  services.xserver.videoDrivers = [ "amdgpu" ];
  hardware.bluetooth.enable = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      vulkan-loader
      vulkan-tools
      rocmPackages.clr.icd
    ];
  };

  networking.hostName = "nixos";
  time.timeZone = "America/Sao_Paulo";

  services.xserver.xkb = {
    layout = "br";
    variant = "";
  };
  console.keyMap = "br-abnt2";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
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

  users.users.nan = {
    isNormalUser = true;
    description = "Nicolas A. N. S.";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "gamemode"
      "adbusers"
      "fuse"
      "audio"
    ];
    shell = pkgs.nushell;
    packages = with pkgs; [ ];
  };
}
