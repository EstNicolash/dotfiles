# ==============================================================================
# Dux Labs Desktop Suite (nixos/user/desktop/dms.nix)
#
# Configures Dux Modular Shell, Dux Files (file manager & XDG
# file chooser portal), Dux Search (indexed filesystem search), Dux Calendar
# (unified calendar daemon), and Dux GOP (system telemetry backend).
# ==============================================================================
{ pkgs, inputs, ... }:

let
  system = pkgs.stdenv.hostPlatform.system;
in
{
  gtk = {
    enable = true;
    gtk3.extraCss = ''@import url("dank-colors.css");'';
    gtk4.extraCss = ''@import url("dank-colors.css");'';
  };
  # ----------------------------------------------------------------------------
  # Dux Suite & Plugin Runtime Dependencies
  # ----------------------------------------------------------------------------
  home.packages = with pkgs; [
    # Telemetry & process monitor backend for DMS system widgets + TUI
    inputs.dgop.packages.${system}.default

    # Unified calendar & task manager (CalDAV, Google, local .ics)
    inputs.dcal.packages.${system}.default

    # Quick Capture plugin dependencies (recording, annotation, OCR & QR)
    gpu-screen-recorder
    wf-recorder
    ffmpeg
    imagemagick
    tesseract
    zbar

    # Phone Connect plugin backend (pairs with Samsung mobile device)
    kdePackages.kdeconnect-kde
  ];

  # Run Dux Calendar daemon silently at login (tray + background sync/reminders)
  systemd.user.services.dcal = {
    Unit = {
      Description = "Dux Calendar Background Daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${inputs.dcal.packages.${system}.default}/bin/dcal run --session --hidden";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };

  # ----------------------------------------------------------------------------
  # Dux Modular Shell
  # ----------------------------------------------------------------------------
  programs.dank-material-shell = {
    enable = true;

    package = inputs.dms.packages.${pkgs.stdenv.hostPlatform.system}.default;

    # Systemd lifecycle management (do NOT enable niri.enableSpawn alongside this)
    systemd = {
      enable = true;
      restartIfChanged = true;
    };



    # Core shell features
    enableSystemMonitoring = true;
    enableVPN = true;
    enableDynamicTheming = false; # Keep static color scheme; do not pull matugen
    enableAudioWavelength = true; # Cava audio visualizer
    enableCalendarEvents = true;
    enableClipboardPaste = true;

    # Niri compositor fragment includes (managed dynamically by DMS)
    niri = {
      enableKeybinds = false;
      enableSpawn = false; # Managed by systemd unit above
      includes = {
        enable = true;
        override = true;
        originalFileName = "hm";
        filesToInclude = [
          "alttab"
          "binds-next"
          "binds"
          #"colors"
          "cursor"
          "layout"
          "outputs"
          "windowrules"
          "wpblur"
        ];
      };
    };

    clipboardSettings = {
      maxHistory = 50;
      clearAtStartup = false;
    };

    # Declarative plugins from dms-plugin-registry
    managePluginSettings = true;
    plugins = {
      quickCapture.enable = true;
      dankKDEConnect.enable = true;


      # Official Dux Labs plugins
      dankPomodoroTimer.enable = true;
      dankActions.enable = true;
      dankHooks.enable = true;
      dankNotepadModule.enable = true;
      dmsThemeSync.enable = true;

      # Hardware, Scheduler & Niri productivity
      dankSchedPicker.enable = true;
      calculator.enable = true;
      niriWindows.enable = true;
      pullWindow.enable = true;
    };

    # Core appearance & automatic lock policy
    settings = {
      theme = "dark";
      dynamicTheming = false;
      currentThemeName = "custom";
      currentThemeCategory = "registry";
      customThemeFile = "${inputs.dms-plugin-registry}/themes/kanagawa-wl/theme.json";

      # Automatic screen lock & suspend integration
      lockBeforeSuspend = true;
      loginctlLockIntegration = true;
      acLockTimeout = 600; # Lock after 10 minutes idle (0 disables)
      acMonitorTimeout = 900;
      fadeToLockEnabled = true;
      fadeToLockGracePeriod = 5;
      lockScreenShowWeather = true;
      lockScreenShowProfileImage = true;

      notificationDndWhileScreenSharing = true;
      notificationPopupAvoidPopouts = true;
      notificationHistoryEnabled = true;
      notificationHistoryMaxAgeDays = 7;
      osdAlwaysShowValue = true;

      weatherEnabled = true;
      useAutoLocation = false;

      dankLauncherV2IncludeFilesInAll = true;
      dankLauncherV2IncludeFoldersInAll = true;
      dankLauncherV2ShowSourceBadges = true;
      rememberLastQuery = false;
      launcherHistoryEnabled = true;
      syncModeWithPortal = true;
      terminalsAlwaysDark = true;


      closeNiriOverviewOnWindowFocus = true;
      niriOverviewOverlayEnabled = true;
      keybindsFloatingWindow = true;
      keybindsModifierStyle = "symbols";
      focusRingEnabled = true;
      focusRingWidth = 2;

      screenshotDir = "/home/nan/Pictures/Screenshots";
      screenshotFormat = "png";
      screenshotClipboard = true;
      screenshotSaveFile = true;
      screenshotCursor = false;

      notepadUseMonospace = true;
      notepadFontFamily = "Fira Code";
      notepadFontSize = 14;
      notepadShowLineNumbers = true;
      notepadAutoSave = true;
      notepadUseCompositorGap = true;

      firstDayOfWeek = 1;
      showWeekNumber = true;
      calendarBackend = "dcal";
      qmlCacheEnabled = true;

      nightModeExcludeFullscreen = true;

    };

    session = {
          weatherLocation = "Porto Alegre, RS";
          weatherCoordinates = "-30.0346,-51.2177";

          wallpaperPath = "/home/nan/Pictures/WallpapersKanagawa/qbi9wh5bfp2h1.jpg";
          wallpaperCyclingEnabled = true;
          wallpaperCyclingInterval = 900;
          wallpaperCyclingMode = "interval";

          nightModeEnabled = true;
          nightModeAutoEnabled = true;
          nightModeAutoMode = "location";
          nightModeTemperature = 4200;
    };


  };

  # ----------------------------------------------------------------------------
  # Dux Files (File Manager & XDG FileChooser Portal)
  # ----------------------------------------------------------------------------
  programs.dux-files = {
    enable = true;

    # Keep resident daemon so windows and file chooser dialogs open instantly
    systemd = {
      enable = true;
      restartIfChanged = true;
    };

    # Serve open/save file dialogs for browsers, Flatpaks, and apps in Niri
    portal = {
      enable = true;
      preferred = true;
      desktop = "niri";
    };
  };

  # Register Dux Files as default directory handler
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = [ "dev.duxlabs.files.desktop" ];
    };
  };

  # ----------------------------------------------------------------------------
  # Dux Search (Indexed Filesystem & Content Search for DMS Launcher)
  # ----------------------------------------------------------------------------
  programs.dsearch = {
    enable = true;

    config = {
      # Keep HTTP API disabled; DMS and CLI communicate securely via Unix socket
      http_enabled = false;
      max_file_bytes = 2097152; # 2MB
      worker_count = 4;
      index_all_files = true;

      text_extensions = [
        ".txt"
        ".md"
        ".nix"
        ".rs"
        ".py"
        ".ts"
        ".tsx"
        ".js"
        ".json"
        ".toml"
        ".yaml"
        ".yml"
        ".tex"
        ".bib"
        ".p4"
        ".sh"
      ];

      index_paths = [
        {
          path = "/home/nan/Documents";
          max_depth = 0;
          exclude_hidden = true;
        }
        {
          path = "/home/nan/dotfiles";
          max_depth = 0;
          exclude_hidden = false;
          merge_default_exclude_dirs = true;
          exclude_dirs = [ ];
        }
      ];
    };
  };
}
