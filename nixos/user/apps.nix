# ==============================================================================
# General Desktop Applications (nixos/user/apps.nix)
#
# Houses everyday user-facing GUI applications that do not belong to software
# development, multimedia production, or academic study.
# ==============================================================================
{ pkgs, ... }:

{
  home.packages = with pkgs; [
    # Secondary web browsers
    microsoft-edge

    # Everyday utilities (image viewer, translation, bookmarks, torrents)
    loupe
    crow-translate
    shiori
    qbittorrent

    metadata-cleaner
    eyedropper
    curtail
  ];
}
