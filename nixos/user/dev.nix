# ==============================================================================
# Development Environment & Editors (nixos/user/dev.nix)
#
# Philosophy: Keep global toolchains minimal. Language-specific compilers,
# runtimes, and LSPs (Rust, Python, LaTeX, P4, C/C++) are isolated per-project
# via Nix Flakes and `nix-direnv`.
# Global tools cover Git, direnv, Nix helpers/formatting, Zed IDE, and Helix
# configured as a lightweight plain-text/notes editor.
# ==============================================================================
{ pkgs, lib, ... }:

{
  # ----------------------------------------------------------------------------
  # Minimal Global Utilities (Nix Ecosystem, Task Runners & Quick Inspection)
  # ----------------------------------------------------------------------------
  home.packages = with pkgs; [
    # Nix language servers, RFC-166 formatter & Rust-based CLI helper
    nixd
    nil
    nixfmt

    # Command runner & shell linting
    just
    shfmt
    shellcheck

    # Quick CLI database & JSON inspection
    sqlite
    jq

    antigravity-cli
    mold
    clang
    sccache
  ];

  # Tell `nh` where your flake lives so `nh os switch` / `nh home switch`
  # work from any directory without passing --flake
  home.sessionVariables = {
    NH_FLAKE = "/home/nan/dotfiles/nixos";
    RUSTC_WRAPPER = "${pkgs.sccache}/bin/sccache";
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_LINKER = "${pkgs.clang}/bin/clang";
    CARGO_TARGET_X86_64_UNKNOWN_LINUX_GNU_RUSTFLAGS = "-C link-arg=-fuse-ld=${pkgs.mold}/bin/mold";
  };

  # ----------------------------------------------------------------------------
  # Git, Diff Viewer (Delta) & Lazygit
  # ----------------------------------------------------------------------------
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Nicolas A. N. S.";
        email = "nicolas.andre263@protonmail.com";
      };
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
    options = {
      navigate = true;
      line-numbers = true;
      side-by-side = false;
    };
  };

  programs.lazygit.enable = true;

  # ----------------------------------------------------------------------------
  # Per-Project Environment Isolation (direnv + nix-direnv)
  # ----------------------------------------------------------------------------
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
  };

  # ----------------------------------------------------------------------------
  # Primary IDE: Zed Editor (Rust & Python are built-in natively)
  # ----------------------------------------------------------------------------
  programs.zed-editor = {
    enable = true;

    extensions = [
      "Kanagawa Themes"
      "nix"
      "latex"
      "toml"
      "sql"
      "nu"
      "Justfile"
      "make"
      "html"
      "csv"
      "Rainbow CSV"
      "git-firefly"
      "activitywatch"
      "Typst"
      "Everforest Theme (regular, material, blur)"
    ];

    userSettings = {
      theme = lib.mkForce "Kanagawa";
      helix_mode = true;

      ui_font_size = lib.mkForce 15;
      buffer_font_size = lib.mkForce 15;

      auto_indent = true;
      auto_indent_on_paste = true;
      load_direnv = "shell_hook";

      features = {
        copilot = true;
      };

      telemetry = {
        metrics = false;
        diagnostics = false;
      };

      tabs = {
        close_position = "right";
        file_icons = false;
        git_status = true;
        activate_on_close = "history";
        show_close_button = "hover";
        show_diagnostics = "off";
      };
    };
  };

  # ----------------------------------------------------------------------------
  # Secondary Editor: Helix (Tuned for Plain-Text, Notes & Quick Config Edits)
  # ----------------------------------------------------------------------------
  programs.helix = {
    enable = true;

    settings = {
      theme = lib.mkForce "stylix";

      editor = {
        line-number = "relative";
        cursorline = true;
        auto-save = true;
        rulers = [ 80 ];

        soft-wrap = {
          enable = true;
          wrap-at-text-width = false;
        };

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
      };
    };
  };
}
