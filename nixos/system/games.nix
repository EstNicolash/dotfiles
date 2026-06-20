{ config, pkgs, ... }:

{
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };

  programs.gamescope.enable = true;
  programs.gamemode.enable = true;

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
    steam-run
    winetricks
    wine
    steamtinkerlaunch
    vulkan-tools
    vulkan-loader
    mesa

    (writeShellScriptBin "protontricks" ''
      exec flatpak run com.github.Matoking.protontricks "$@"
    '')
  ];
}
