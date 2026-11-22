# ==============================================================================
# Home Manager Entry Point (nixos/user/home.nix)
#
# Aggregates modular user-space configurations (shell, development, desktop,
# media, study, gaming, and applications) and defines core user identity,
# nixpkgs settings, and Home Manager state version.
# ==============================================================================
{ ... }:

{
  # ----------------------------------------------------------------------------
  # User Module Imports
  # ----------------------------------------------------------------------------
  imports = [
    # Core CLI & development environment
    ./terminal.nix
    ./dev.nix
    ./system.nix

    # Wayland desktop environment (Niri, DMS, Stylix)
    ./desktop/wm.nix
    ./desktop/dms.nix
    ./desktop/theme.nix

    # Applications & domain-specific tools
    ./apps.nix
    ./comm.nix
    ./media.nix
    ./study.nix
    ./games.nix
    ./backup.nix
  ];

  # ----------------------------------------------------------------------------
  # User Identity & Home Manager Core
  # ----------------------------------------------------------------------------
  home = {
    username = "nan";
    homeDirectory = "/home/nan";
    # Do not change unless performing a manual Home Manager state migration
    stateVersion = "25.05";
  };

  gtk = {
    enable = true;
    gtk3.extraCss = ''@import url("dank-colors.css");'';
    gtk4.extraCss = ''@import url("dank-colors.css");'';
  };

  # Allow unfree packages in standalone Home Manager nixpkgs evaluation
  nixpkgs.config.allowUnfree = true;

  # Let Home Manager manage itself
  programs.home-manager.enable = true;
}
