{ pkgs, lib, ... }:

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
    obsidian
    calibre
    sioyek
    spedread
    geogebra6

    hunspell
    hunspellDicts.en_US
    hunspellDicts.pt_BR
    hunspellDicts.pt_PT
  ];

  xdg.configFile = {
    "Anki2/addons21/recolor".source = "${pkgs.ankiAddons.recolor}/share/anki/addons/recolor";
    "Anki2/addons21/recolor/config.json".text = builtins.toJSON {
      colors = {
        ACCENT = [
          "Accent"
          "#88c0d0"
          "#8fbcbb"
          "--accent"
        ];
        ACCENT_CARD = [
          "Card mode"
          "#81a1c1"
          "#5e81ac"
          "--accent-card"
        ];
        BACKGROUND_MAIN = [
          "Main Background"
          "#2e3440"
          "#2e3440"
          "--background-main"
        ];
        BACKGROUND_CARD = [
          "Card Background"
          "#3b4252"
          "#3b4252"
          "--background-card"
        ];
        BACKGROUND_POPUP = [
          "Popup Background"
          "#434c5e"
          "#434c5e"
          "--background-popup"
        ];
        TEXT_MAIN = [
          "Main Text"
          "#d8dee9"
          "#e5e9f0"
          "--text-main"
        ];
        TEXT_CARD = [
          "Card Text"
          "#e5e9f0"
          "#eceff4"
          "--text-card"
        ];
        BORDER = [
          "Borders"
          "#4c566a"
          "#4c566a"
          "--border"
        ];
        BUTTON_AGAIN = [
          "Again Button"
          "#bf616a"
          "#bf616a"
          "--button-again"
        ];
        BUTTON_HARD = [
          "Hard Button"
          "#d08770"
          "#d08770"
          "--button-hard"
        ];
        BUTTON_GOOD = [
          "Good Button"
          "#a3be8c"
          "#a3be8c"
          "--button-good"
        ];
        BUTTON_EASY = [
          "Easy Button"
          "#b48ead"
          "#b48ead"
          "--button-easy"
        ];
      };
      version = {
        major = 3;
        minor = 3;
      };
    };
  };

}
