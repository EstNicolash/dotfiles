# ==============================================================================
# Academic Study, Research & Reading Tools (nixos/user/study.nix)
#
# Configures library management (Calibre), non-destructive academic PDF
# annotation & bibliography (Zotero), knowledge management (Obsidian),
# readers (Foliate for EPUB/CBZ, Papers for quick PDFs),
# dictionaries (Hunspell), and mathematical visualization (GeoGebra).
# ==============================================================================
{ pkgs, ... }:

{
  programs.anki = {
      enable = true;
      minimalistMode = true;
      theme = "dark";
      videoDriver = "opengl";

      addons = with pkgs.ankiAddons; [
        review-heatmap
        fsrs4anki-helper
        anki-connect
      ];
    };


  home.packages = with pkgs; [
    # Library management, reference tracking & note-taking
    calibre
    obsidian

    # read
    foliate
    papers


    typst
    tinymist
    normcap

    geogebra6


    hunspell
    hunspellDicts.en_US
    hunspellDicts.pt_BR
    hunspellDicts.pt_PT
  ];
}
