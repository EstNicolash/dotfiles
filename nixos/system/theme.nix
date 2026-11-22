# ==============================================================================
# System-Wide Stylix Theming (nixos/system/theme.nix)
#
# Configures global Stylix polarity, Kanagawa color scheme, cursor theme,
# and system typography (monospace, sans-serif, serif, and font sizes).
# ==============================================================================
{ pkgs, ... }:

{
  stylix = {
    enable = true;
    polarity = "dark";

    # Kanagawa Wave base16 scheme (bundled in base16-schemes)
    base16Scheme = "${pkgs.base16-schemes}/share/themes/kanagawa.yaml";

    # Cursor theme
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Classic";
      size = 24;
    };

    # System Typography
    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font";
      };

      sansSerif = {
        package = pkgs.inter;
        name = "Inter";
      };

      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };

      emoji = {
        package = pkgs.noto-fonts-color-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 11;
        popups = 11;
      };
    };
  };
}
