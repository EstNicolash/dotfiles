{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./terminal.nix
    ./dev.nix

    ./desktop/dms.nix
    ./desktop/wm.nix
    ./desktop/theme.nix

    ./comm.nix
    ./media.nix
    ./study.nix
    ./system.nix
    ./games.nix
    ./apps.nix
    ./backup.nix

  ];

  nixpkgs.config.allowUnfree = true;
  wayland.windowManager.hyprland.configType = "lua";

  home.username = "nan";
  home.homeDirectory = "/home/nan";
  home.stateVersion = "25.05";

  home.sessionVariables = {
    XDG_MENU_PREFIX = "plasma-";

    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "kde";
    QT_QPA_PLATFORMTHEME_QT6 = "kde";

    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_ENABLE_HIGHDPI_SCALING = "1";
    QT_SCALE_FACTOR_ROUNDING_POLICY = "RoundPreferFloor";
    XDG_DATA_DIRS = "$HOME/.nix-profile/share:$HOME/.local/share/flatpak/exports/share:/var/lib/flatpak/exports/share:/run/current-system/sw/share";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";

    GTK_DECORATION_LAYOUT = "";
  };

  programs.home-manager.enable = true;
}
