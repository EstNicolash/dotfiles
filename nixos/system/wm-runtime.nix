{ pkgs, inputs, ... }:

{
  services.xserver.enable = true;
  services.displayManager.gdm.enable = false;

  services.displayManager.dms-greeter = {
    enable = true;

    package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;
    quickshell.package = pkgs.quickshell;

    compositor = {
      name = "niri";
    };

    configHome = "/home/nan";
  };

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
  };

  nix.settings.substituters = [ "https://niri.cachix.org" ];
  nix.settings.trusted-public-keys = [
    "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
  ];

  xdg.portal = {
    enable = true;
    config.niri = {
      default = [ "kde" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
    };
    extraPortals = with pkgs; [
      kdePackages.xdg-desktop-portal-kde
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    wayland
    xwayland
    xwayland-satellite
    mate-polkit
  ];
}
