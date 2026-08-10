{ pkgs, ... }:

{
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      wlrobs
      obs-backgroundremoval
      obs-pipewire-audio-capture
      obs-vaapi
      obs-gstreamer
      obs-vkcapture
    ];
  };

  programs.cava = {
    enable = true;
    settings = {
      general.channels = "mono";
      color = {
        gradient = 1;
        gradient_count = 6;
        gradient_color_1 = "'#5E81AC'"; # Nord 10
        gradient_color_2 = "'#81A1C1'"; # Nord 9
        gradient_color_3 = "'#88C0D0'"; # Nord 8
        gradient_color_4 = "'#8FBCBB'"; # Nord 7
        gradient_color_5 = "'#B48EAD'"; # Nord 15
        gradient_color_6 = "'#A3BE8C'"; # Nord 14
      };
      smoothing = {
        monstercat = 0;
        waves = 0;
        integral = 85;
        gravity = 90;
        noise_reduction = 80;
      };
    };
  };

  home.packages = with pkgs; [
    ffmpeg
    # kdePackages.kdenlive

    #freetube
  ];
}
