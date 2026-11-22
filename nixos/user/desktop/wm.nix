# ==============================================================================
#
# Niri Wayland Compositor Configuration (nixos/user/desktop/wm.nix)
#
# Configures Niri input devices, scrollable tiling layout, layer/window rules,
# and custom compositor keybindings.
# ==============================================================================
{ ... }:

{

  programs.niri.settings = {

    outputs = {
      "DP-1" = {
        focus-at-startup = true;
        mode = {
          width = 1920;
          height = 1080;
          refresh = 179.998;
        };
        position = {
          x = 1920;
          y = 0;
        };
        variable-refresh-rate = "on-demand";
      };

      "HDMI-A-1" = {
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.000;
        };
        position = {
          x = 0;
          y = 0;
        };
        variable-refresh-rate = false;
      };
    };

    spawn-at-startup = [
      { command = [ "xrandr" "--output" "DP-1" "--primary" ]; }
    ];

    # --------------------------------------------------------------------------
    # Input Devices
    # --------------------------------------------------------------------------
    input = {
      keyboard = {
        numlock = true;
        xkb = {
          layout = "br";
          variant = "abnt2";
        };
      };

      touchpad = {
        tap = true;
        natural-scroll = true;
      };
    };

    # --------------------------------------------------------------------------
    # Scrollable Tiling Layout & Aesthetics
    # --------------------------------------------------------------------------
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
        active.color = "#e6c384";
        inactive.color = "#54546d";
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

    # --------------------------------------------------------------------------
    # Wayland Environment & General Behavior
    # --------------------------------------------------------------------------
    environment = {
      XDG_CURRENT_DESKTOP = "niri";
      QT_QPA_PLATFORM = "wayland";
      GTK_DECORATION_LAYOUT = "";
      TERMINAL = "ghostty";
    };

    hotkey-overlay.skip-at-startup = true;
    screenshot-path = "~/Pictures/Screenshots/Screenshot-%Y-%m-%d_%H-%M-%S.png";
    animations.enable = true;
    config-notification.disable-failed = true;

    # --------------------------------------------------------------------------
    # Layer & Window Rules
    # --------------------------------------------------------------------------
    layer-rules = [
      # Place DMS wallpaper & blur surfaces into Niri's overview backdrop
      {
        matches = [ { namespace = "^quickshell$"; } ];
        place-within-backdrop = true;
      }
      {
        matches = [ { namespace = "^dms:blurwallpaper$"; } ];
        place-within-backdrop = true;
      }
      # Block clipboard history from screen captures/recordings
      {
        matches = [ { namespace = "^dms:clipboard$"; } ];
        block-out-from = "screencast";
      }
    ];

    window-rules = [
      # Rounded corners for all windows
      {
        geometry-corner-radius = {
          top-left = 12.0;
          top-right = 12.0;
          bottom-left = 12.0;
          bottom-right = 12.0;
        };
        clip-to-geometry = true;
      }

      # Floating DMS dialogs & Dux Files open/save portals
      {
        matches = [ { app-id = "^dev\\.duxlabs\\.shell$"; } ];
        open-floating = true;
      }
      {
        matches = [
          {
            app-id = "^dev\\.duxlabs\\.files$";
            title = "^(Open|Save|Select|Upload|Export|Import)";
          }
        ];
        open-floating = true;
      }

      # Floating browser Picture-in-Picture
      {
        matches = [
          {
            app-id = "^(firefox|zen.*)$";
            title = "^Picture-in-Picture$";
          }
        ];
        open-floating = true;
      }

      # Disable compositor border behind Ghostty background
      {
        matches = [ { app-id = "^com\\.mitchellh\\.ghostty$"; } ];
        draw-border-with-background = false;
      }

      {
        matches = [
          { app-id = "^heroic$"; }
          { app-id = "^hu\\.kramo\\.Cartridges$"; }
          { app-id = "^org\\.prismlauncher\\.PrismLauncher$"; }
          { app-id = "(?i)^recomp[-_]?launcher$"; }
        ];
        open-on-output = "DP-1";
      }

      {
        matches = [
          { app-id = "^gamescope$"; }
          { app-id = "^steam_app_.*$"; }
          { app-id = "(?i).*\\.exe$"; }

          { title = "^Minecraft.*"; }
          { app-id = "(?i)^brogue(-ce)?$"; }

          { app-id = "(?i).*(recomp|prime).*"; }

          { app-id = "(?i).*(azahar|dolphin-emu|pcsx2|bsnes|mesen|mgba|sameboy).*"; }
        ];
        open-on-output = "DP-1";
        open-fullscreen = true;
      }
    ];

    # --------------------------------------------------------------------------
    # Custom Keybindings (DMS shell binds are loaded via dms/binds.kdl)
    # --------------------------------------------------------------------------
    binds = {
      # Core applications & Dux suite shortcuts
      "Mod+T".action.spawn = [ "ghostty" "+new-window" ];
      "Mod+Return".action.spawn = [ "ghostty" "+toggle-quick-terminal" ];

      "Mod+Shift+S".action.spawn = [ "dms" "ipc" "call" "quickCapture" "toggle" ];
      "Mod+G".action.spawn = [ "dms" "ipc" "call" "pullWindow" "toggle" ];
      "Mod+X".action.spawn = [ "dms" "ipc" "call" "powermenu" "toggle" ];

      "Mod+E".action.spawn = [
        "dfiles"
        "ipc"
        "ui.toggle"
      ];
      "Mod+Shift+C".action.spawn = [
        "dcal"
        "ipc"
        "ui.toggle"
      ];
      "Alt+Space".action.spawn = [
        "dms"
        "ipc"
        "call"
        "spotlight-bar"
        "toggle"
      ];

      # Window & overview management
      "Mod+Q" = {
        repeat = false;
        action.close-window = { };
      };
      "Mod+O" = {
        repeat = false;
        action.toggle-overview = { };
      };
      "Mod+Alt+F".action.toggle-window-floating = { };
      "Mod+F".action.maximize-column = { };
      "Mod+Shift+F".action.fullscreen-window = { };

      # Column navigation (Arrows & Vim keys)
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

      # Column sizing & grouping
      "Mod+BracketLeft".action.consume-or-expel-window-left = { };
      "Mod+BracketRight".action.consume-or-expel-window-right = { };
      "Mod+Period".action.expel-window-from-column = { };
      "Mod+R".action.switch-preset-column-width = { };
      "Mod+Minus".action.set-column-width = "-10%";
      "Mod+Equal".action.set-column-width = "+10%";

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

      # Multi-monitor navigation
      "Mod+Alt+Left".action.focus-monitor-left = { };
      "Mod+Alt+Right".action.focus-monitor-right = { };
      "Mod+Alt+Up".action.focus-monitor-up = { };
      "Mod+Alt+Down".action.focus-monitor-down = { };
      "Mod+Alt+Ctrl+Left".action.move-column-to-monitor-left = { };
      "Mod+Alt+Ctrl+Right".action.move-column-to-monitor-right = { };

      # Screenshots
      "Print".action.screenshot = { };
      "Ctrl+Print".action.screenshot-screen = { };
      "Alt+Print".action.screenshot-window = { };

      # Session & escape hatch
      "Mod+Escape" = {
        allow-inhibiting = false;
        action.toggle-keyboard-shortcuts-inhibit = { };
      };
      "Mod+Shift+E".action.quit = { };
    };
  };
}
