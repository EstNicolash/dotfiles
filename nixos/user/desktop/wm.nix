{ pkgs, lib, ... }:

{
  home.packages = with pkgs; [
    fuzzel
    playerctl
    kdePackages.qt6ct
  ];

  services.gammastep = {
    enable = true;
    tray = true;
    provider = "manual";
    longitude = -51.2303767;
    latitude = -30.0324999;

    settings = {
      general = {
        method = "wlr";
        temp-day = lib.mkForce 6500;
        temp-night = lib.mkForce 3300;
        fade = 1;
        gamma-day = 1.0;
        gamma-night = 0.7;
      };
    };
  };

  programs.niri.settings = {
    input = {
      keyboard = {
        numlock = true;
      };
      touchpad = {
        tap = true;
        natural-scroll = true;
      };
    };

    layout = {
      gaps = 8;
      background-color = "transparent";
      center-focused-column = "never";

      preset-column-widths = [
        { proportion = 0.33333; }
        { proportion = 0.5; }
        { proportion = 0.66667; }
      ];

      default-column-width = {
        proportion = 0.5;
      };

      focus-ring = {
        enable = true;
        width = 2;
        active.color = "#d08770";
        inactive.color = "#505050";
      };

      border.enable = false;

      shadow = {
        enable = true;
        softness = 30;
        spread = 5;
        offset = {
          x = 0;
          y = 5;
        };
        color = "#0007";
      };
    };

    environment = {
      XDG_CURRENT_DESKTOP = "niri";
      QT_QPA_PLATFORM = "wayland";
      ELECTRON_OZONE_PLATFORM_HINT = "auto";
      QT_QPA_PLATFORMTHEME = "gtk3";
      QT_QPA_PLATFORMTHEME_QT6 = "gtk3";
    };

    spawn-at-startup = [
      {
        command = [
          "bash"
          "-c"
          "wl-paste --watch cliphist store &"
        ];
      }
    ];

    hotkey-overlay.skip-at-startup = true;
    screenshot-path = "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png";
    animations.enable = true;

    layer-rules = [
      {
        matches = [ { namespace = "quickshell"; } ];
        place-within-backdrop = true;
      }
      {
        matches = [ { namespace = "dms:blurwallpaper"; } ];
        place-within-backdrop = true;
      }
    ];

    window-rules = [
      {
        matches = [ { app-id = "org.quickshell$"; } ];
        open-floating = true;
      }
      {
        matches = [
          {
            app-id = "firefox$";
            title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
      }
      {
        matches = [ { app-id = "kitty"; } ];
        draw-border-with-background = false;
      }
      {
        matches = [ { is-active = false; } ];
        opacity = 1.0;
      }
      {
        geometry-corner-radius = {
          top-left = 12.0;
          top-right = 12.0;
          bottom-left = 12.0;
          bottom-right = 12.0;
        };
        clip-to-geometry = true;
      }
    ];

    config-notification.disable-failed = true;

    binds = {
      # Atalhos nativos do seu ecossistema
      "Mod+Shift+Slash".action.show-hotkey-overlay = { };
      "Mod+T".action.spawn = "kitty";
      "Mod+Q" = {
        repeat = false;
        action.close-window = { };
      };
      "Mod+O" = {
        repeat = false;
        action.toggle-overview = { };
      };

      # Controles de mídia puros (Playerctl)
      "XF86AudioPlay" = {
        allow-when-locked = true;
        action.spawn = [
          "playerctl"
          "play-pause"
        ];
      };
      "XF86AudioStop" = {
        allow-when-locked = true;
        action.spawn = [
          "playerctl"
          "stop"
        ];
      };
      "XF86AudioPrev" = {
        allow-when-locked = true;
        action.spawn = [
          "playerctl"
          "previous"
        ];
      };
      "XF86AudioNext" = {
        allow-when-locked = true;
        action.spawn = [
          "playerctl"
          "next"
        ];
      };

      # Movimentação e Navegação do Niri
      "Mod+Left".action.focus-column-left = { };
      "Mod+Down".action.focus-window-down = { };
      "Mod+Up".action.focus-window-up = { };
      "Mod+Right".action.focus-column-right = { };
      "Mod+H".action.focus-column-left = { };
      "Mod+J".action.focus-window-down = { };
      "Mod+K".action.focus-window-up = { };
      "Mod+L".action.focus-column-right = { };

      "Mod+Ctrl+Left".action.move-column-left = { };
      "Mod+Ctrl+Down".action.move-window-down = { };
      "Mod+Ctrl+Up".action.move-window-up = { };
      "Mod+Ctrl+Right".action.move-column-right = { };
      "Mod+Ctrl+H".action.move-column-left = { };
      "Mod+Ctrl+J".action.move-window-down = { };
      "Mod+Ctrl+K".action.move-window-up = { };
      "Mod+Ctrl+L".action.move-column-right = { };

      "Mod+Home".action.focus-column-first = { };
      "Mod+End".action.focus-column-last = { };

      # Workspaces
      "Mod+1".action.focus-workspace = 1;
      "Mod+2".action.focus-workspace = 2;
      "Mod+3".action.focus-workspace = 3;
      "Mod+4".action.focus-workspace = 4;
      "Mod+5".action.focus-workspace = 5;
      "Mod+6".action.focus-workspace = 6;
      "Mod+7".action.focus-workspace = 7;
      "Mod+8".action.focus-workspace = 8;
      "Mod+9".action.focus-workspace = 9;
      "Mod+Ctrl+1".action.move-column-to-workspace = 1;
      "Mod+Ctrl+2".action.move-column-to-workspace = 2;
      "Mod+Ctrl+3".action.move-column-to-workspace = 3;
      "Mod+Ctrl+4".action.move-column-to-workspace = 4;
      "Mod+Ctrl+5".action.move-column-to-workspace = 5;
      "Mod+Ctrl+6".action.move-column-to-workspace = 6;
      "Mod+Ctrl+7".action.move-column-to-workspace = 7;
      "Mod+Ctrl+8".action.move-column-to-workspace = 8;
      "Mod+Ctrl+9".action.move-column-to-workspace = 9;

      "Mod+Alt+Left".action.focus-monitor-left = { };
      "Mod+Alt+Right".action.focus-monitor-right = { };
      "Mod+Alt+Up".action.focus-monitor-up = { };
      "Mod+Alt+Down".action.focus-monitor-down = { };

      "Mod+Alt+Ctrl+Left".action.move-column-to-monitor-left = { };
      "Mod+Alt+Ctrl+Right".action.move-column-to-monitor-right = { };
      # Manipulação de Janelas
      "Mod+BracketLeft".action.consume-or-expel-window-left = { };
      "Mod+BracketRight".action.consume-or-expel-window-right = { };
      "Mod+Period".action.expel-window-from-column = { };
      "Mod+R".action.switch-preset-column-width = { };
      "Mod+F".action.maximize-column = { };
      "Mod+Shift+F".action.fullscreen-window = { };
      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";
      "Mod+Alt+F".action.toggle-window-floating = { };

      # Prints
      "Print".action.screenshot = { };
      "Ctrl+Print".action.screenshot-screen = { };
      "Alt+Print".action.screenshot-window = { };

      "Mod+Escape" = {
        allow-inhibiting = false;
        action.toggle-keyboard-shortcuts-inhibit = { };
      };
      "Mod+Shift+E".action.quit = { };
    };
  };
}
