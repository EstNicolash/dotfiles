{ pkgs, ... }:

{

  home.packages = with pkgs; [
    anytype
    ticktick
    ferdium
    shiori
    activitywatch

  ];

  services.activitywatch = {
    enable = true;

    settings = {
      server = {
        host = "127.0.0.1";
        port = 5600;
      };
    };

    watchers = {
      awatcher = {
        package = pkgs.awatcher;
        extraOptions = [
          "--watch-window"
          "--watch-afk"
        ];
      };

    };

  };
}
