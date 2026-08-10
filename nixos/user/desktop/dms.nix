{ pkgs, inputs, ... }: {
  imports = [
    # inputs.dms-plugin-registry.modules.default
  ];

  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    session = {
      terminalOverride = "${pkgs.kitty}/bin/kitty -e ${pkgs.nushell}/bin/nu";

      currentThemeName = "nord";
      currentThemeCategory = "generic";

      weatherLocation = "Porto Alegre, RS";
      weatherCoordinates = "-30.0325,-51.2304";
      weatherHourlyDetailed = true;

      wallpaperPath = "/home/nan/Pictures/Wallpapers/16.png";
      wallpaperPathDark = "/home/nan/Pictures/Wallpapers/16.png";
      wallpaperCyclingEnabled = true;
      wallpaperCyclingMode = "interval";
      wallpaperCyclingInterval = 600;
      wallpaperTransition = "fade";
    };

    niri = {
      includes = {
        enable = true;
        override = true;
        originalFileName = "hm";
        filesToInclude = [
          "alttab"
          "binds"
          "colors"
          "layout"
          "outputs"
          "wpblur"
        ];
      };
    };

    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = false;
    enableAudioWavelength = true;
    enableCalendarEvents = true;
    enableClipboardPaste = true;

    clipboardSettings = {
      maxHistory = 30;
      clearAtStartup = true;
    };

    settings = {
      theme = "dark";
      dynamicTheming = false;
    };

    session = {
      isLightMode = false;
    };
  };
}
