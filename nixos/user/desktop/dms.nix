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

    niri = {
      includes = {
        enable = true;
        override = false;
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
    enableDynamicTheming = true;
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
