# ==============================================================================
# Terminal, Shell & CLI Utilities (nixos/user/terminal.nix)
#
# Configures the user terminal emulator (Ghostty), interactive shell (Nushell),
# prompt (Oh My Posh), GitHub CLI, and modern Rust CLI tools (bat, fd, ripgrep,
# zoxide, dust, ouch).
# ==============================================================================
{ config, pkgs, ... }:

{
  # ----------------------------------------------------------------------------
  # User Binary Paths
  # ----------------------------------------------------------------------------
  home.sessionPath = [
    "${config.home.homeDirectory}/.cache/npm/global/bin"
    "${config.home.homeDirectory}/go/bin"
  ];

  # ----------------------------------------------------------------------------
  # Modern CLI Utilities (Rust-based replacements)
  # ----------------------------------------------------------------------------
  home.packages = with pkgs; [
    fd # Fast file finder (replaces find)
    ripgrep # Fast recursive regex search (replaces grep)
    dust # Intuitive disk usage analyzer with bar charts (replaces du)
    ouch # Universal archive compressor/decompressor (tar, zip, zst, 7z)
  ];

  # ----------------------------------------------------------------------------
  # Terminal Emulator (Ghostty — Wayland-native, themed automatically by Stylix)
  # ----------------------------------------------------------------------------
  programs.ghostty = {
    enable = true;
    settings = {
      command = "${pkgs.nushell}/bin/nu";
      window-padding-x = 10;
      window-padding-y = 10;
      confirm-close-surface = false;
      copy-on-select = "clipboard";
      gtk-single-instance = true;
      quit-after-last-window-closed = false;
      quit-after-last-window-closed-delay = "10m";
      window-decoration = false;
      quick-terminal-position = "top";
      quick-terminal-screen = "mouse";
      quick-terminal-animation-duration = 0.1;
    };
  };

  systemd.user.services.ghostty-daemon = {
    Unit = {
      Description = "Ghostty Terminal Daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      ExecStart = "${pkgs.ghostty}/bin/ghostty --gtk-single-instance=true --initial-window=false";
      Restart = "on-failure";
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };

  # ----------------------------------------------------------------------------
  # Interactive Shell (Nushell) & Smart Navigation
  # ----------------------------------------------------------------------------
  programs.nushell = {
    enable = true;
    loadSessionVariables = true;

    shellAliases = {
      # NixOS & Home Manager flake management
      sys-update = "nix flake update --flake ~/dotfiles/nixos/";
      sys-rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos/#nixos";
      home-rebuild = "home-manager switch --flake ~/dotfiles/nixos/#nan";

      # Quick directory jumps
      gon = "cd ~/dotfiles/nixos/";
      goc = "cd ~/Code/";

      # Clean copy-friendly cat output without pager mouse capture
      catp = "bat --style=plain --paging=never";
    };

    extraEnv = ''
      $env.PATH = (
        $env.PATH
        | prepend "${config.home.homeDirectory}/go/bin"
        | prepend "${config.home.homeDirectory}/.cache/npm/global/bin"
      )
      $env.config.show_banner = false
    '';
  };

  # Smart directory jumper (`z <partial-name>`) integrated into Nushell
  programs.zoxide = {
    enable = true;
    enableNushellIntegration = true;
  };

  programs.carapace = {
    enable = true;
    enableNushellIntegration = true;
  };

  # Syntax-highlighted file viewer configured for clean text selection/copying
  programs.bat = {
    enable = true;
    config = {
      style = "numbers,changes";
      pager = "less -FR";
    };
  };

  # ----------------------------------------------------------------------------
  # Prompt, Diagnostics & GitHub CLI
  # ----------------------------------------------------------------------------
  programs.oh-my-posh = {
    enable = true;
    enableNushellIntegration = true;
    useTheme = "emodipt-extend";
  };

  programs.fastfetch.enable = true;

  programs.gh = {
    enable = true;
    gitCredentialHelper.enable = true;
    extensions = [ pkgs.gh-eco ];
    settings = {
      version = "1";
      aliases = {
        "as" = "auth status";
      };
    };
  };
}
