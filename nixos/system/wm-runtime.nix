# ==============================================================================
# Wayland Desktop & Window Manager Runtime (nixos/system/wm-runtime.nix)
#
# Configures the system-level graphical runtime required by Niri and
# DankMaterialShell: display manager (dms-greeter), Niri compositor,
# XDG desktop portals, PipeWire audio stack, Polkit, Flatpak, and XWayland
# compatibility via xwayland-satellite.
# ==============================================================================
{ pkgs, inputs, ... }:

{
  imports = [
    inputs.dank-greeter.nixosModules.default
  ];

  # ----------------------------------------------------------------------------
  # Display Manager & Wayland Compositor
  # ----------------------------------------------------------------------------
  programs = {
    dms-greeter = {
      enable = true;
      package = inputs.dank-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
      compositor.name = "niri";
      configHome = "/home/nan";
    };

    niri = {
      enable = true;
      package = pkgs.niri-unstable;
    };
  };

  # ----------------------------------------------------------------------------
  # XDG Desktop Portals & Secrets
  # ----------------------------------------------------------------------------
  # Use GTK file chooser portal and GNOME portal
  # for PipeWire screen casting in Niri.
  xdg.portal = {
    enable = true;
    config.niri = {
      default = [ "gtk" ];
      "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
      "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
    };
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  services.gnome.gnome-keyring.enable = true;

  # ----------------------------------------------------------------------------
  # Audio Stack (PipeWire)
  # ----------------------------------------------------------------------------
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;

    # Avoids Codec changes
    wireplumber.extraConfig."51-bluetooth-profile" = {
      "wireplumber.settings" = {
        "bluetooth.autoswitch-to-headset-profile" = false;
      };
    };
  };

  # ----------------------------------------------------------------------------
  # Privilege Elevation, Accounts & Flatpak Support
  # ----------------------------------------------------------------------------
  security.polkit.enable = true;
  services.accounts-daemon.enable = true;
  services.flatpak.enable = true;

  # ----------------------------------------------------------------------------
  # Wayland Environment & X11 Compatibility
  # ----------------------------------------------------------------------------
  # Force Electron/Chromium apps to use native Wayland backend
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  environment.systemPackages = with pkgs; [
    # Rootless XWayland integration required by Niri for X11 apps (e.g., Steam)
    xwayland-satellite
    # Dialog helper used by scripts and third-party launchers
    zenity
  ];
}
