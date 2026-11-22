# ==============================================================================
# System Integration, Maintenance & Security Utilities (nixos/user/system.nix)
#
# Configures `nh` (Nix Helper) for flake rebuilds and store garbage collection,
# Rust-based system inspection tools (`cyme`, `bottom`, `systemctl-tui`),
# Wayland clipboard/notification plumbing, VPN/encryption/password tools,
# cloud sync (`rclone`), and XDG MIME default applications.
# ==============================================================================
{ pkgs, ... }:

let
  warehouseFixed = pkgs.symlinkJoin {
    name = "warehouse-wrapped";
    paths = [ pkgs.warehouse ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/warehouse \
        --prefix PYTHONPATH : "${pkgs.python3.withPackages (ps: [ ps.pygobject3 ])}/${pkgs.python3.sitePackages}" \
        --prefix GI_TYPELIB_PATH : "${pkgs.lib.makeSearchPath "lib/girepository-1.0" [ pkgs.gtk4 pkgs.libadwaita pkgs.glib.out ]}"
    '';
  };
in
{
  # ----------------------------------------------------------------------------
  # Nix CLI Helper (`nh` — Diffs, Visual Progress & Automated Store Cleanup)
  # ----------------------------------------------------------------------------
  programs.nh = {
    enable = true;
    flake = "/home/nan/dotfiles/nixos";

    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = [
        "--keep"
        "5"
        "--keep-since"
        "7d"
      ];
    };
  };

  # Cloud storage synchronization CLI
  programs.rclone.enable = true;

  # ----------------------------------------------------------------------------
  # System Plumbing, Rust Hardware/Process Monitors & Security Tools
  # ----------------------------------------------------------------------------
  home.packages = with pkgs; [
    # Wayland & XDG desktop integration
    xdg-utils
    shared-mime-info
    libnotify
    wl-clipboard

    # Rust-based hardware, process & systemd inspection
    cyme          # Modern Rust replacement for `lsusb`
    bottom        # Lightweight Rust system & process monitor (`btm`)
    systemctl-tui # Fast Rust TUI for systemd services & logs
    dua           # Fast Rust interactive disk usage analyzer & cleaner (`dua i`)

    warehouseFixed     # Manage Flatpaks, user data & orphaned runtimes
    czkawka       # Fast Rust + GTK4 duplicate & junk file finder

    # Audio profile switcher (fallback for Bluetooth codec switching) & camera
    pavucontrol
    gphoto2

    # Encryption, credentials & VPNs
    age
    bitwarden-desktop
    wireguard-tools
    proton-vpn
  ];

  # ----------------------------------------------------------------------------
  # Default XDG MIME Associations
  # ----------------------------------------------------------------------------
  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = [ "zed.desktop" ];
        "application/pdf" = [ "org.gnome.Papers.desktop" ];
        "application/epub+zip" = [ "com.github.johnfactotum.Foliate.desktop" ];
        "x-scheme-handler/discord" = [ "vesktop.desktop" ];
        "x-scheme-handler/http" = [ "app.zen_browser.zen.desktop" ];
        "x-scheme-handler/https" = [ "app.zen_browser.zen.desktop" ];

        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];
        "image/svg+xml" = [ "org.gnome.Loupe.desktop" ];

        "audio/mpeg" = [ "io.bassi.Amberol.desktop" ];
        "audio/mp4" = [ "io.bassi.Amberol.desktop" ];
        "audio/ogg" = [ "io.bassi.Amberol.desktop" ];
        "audio/wav" = [ "io.bassi.Amberol.desktop" ];
        "audio/flac" = [ "io.bassi.Amberol.desktop" ];

        "video/mp4" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
      };
    };
  };
}
