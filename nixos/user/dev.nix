{ config
, pkgs
, lib
, ...
}:

{
  programs.git = {
    enable = true;
    settings = {
      user.name = "Nicolas A. N. S.";
      user.email = "nicolas.andre263@protonmail.com";
    };
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableNushellIntegration = true;
  };

  programs.zed-editor = {
    enable = true;
    extensions = [
      "nix"
      "nordic-theme"
      "make"
      "html"
      "toml"
      "git-firefly"
      "csv"
      "haskell"
      "nu"
      "R"
      "Rainbow CSV"
      "NeoCMake"
      "activitywatch"
    ];
    userSettings = {
      features = {
        copilot = true;
      };
      telemetry = {
        metrics = false;
      };
      helix_mode = true;
      ui_font_size = lib.mkForce 16;
      buffer_font_size = lib.mkForce 16;
      auto_ident = true;
      auto_indent_on_paste = true;
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

  programs.helix = {
    enable = true;
    settings = {
      theme = lib.mkForce "stylix";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
      };
    };

    languages = {
      language-server = {
        clangd = {
          command = "clangd";
          args = [ "--log=error" ];
        };
        typescript-language-server = {
          command = "${pkgs.typescript-language-server}/bin/typescript-language-server";
          args = [ "--stdio" ];
        };
        haskell-language-server = {
          command = "haskell-language-server-wrapper";
          args = [ "--lsp" ];
        };
        nil = {
          command = "nil";
        };
      };

      language = [
        {
          name = "c";
          auto-format = true;
          formatter = {
            command = "clang-format";
            args = [ "--style=file" ];
          };
          language-servers = [ "clangd" ];
        }
        {
          name = "cpp";
          auto-format = true;
          formatter = {
            command = "clang-format";
            args = [ "--style=file" ];
          };
          language-servers = [ "clangd" ];
        }
        {
          name = "javascript";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "babel"
            ];
          };
          language-servers = [ "typescript-language-server" ];
        }
        {
          name = "typescript";
          auto-format = true;
          formatter = {
            command = "prettier";
            args = [
              "--parser"
              "typescript"
            ];
          };
          language-servers = [ "typescript-language-server" ];
        }
        {
          name = "haskell";
          auto-format = true;
          formatter = {
            command = "stylish-haskell";
          };
          language-servers = [ "haskell-language-server" ];
        }
        {
          name = "nix";
          auto-format = true;
          formatter = {
            command = "nixpkgs-fmt";
          };
          language-servers = [ "nil" ];
        }
      ];
    };
  };

  home.packages = with pkgs; [


    antigravity-cli
    vscode-fhs
    tree-sitter

    # --- Nix ---
    nixfmt
    nixpkgs-fmt
    nixd
    nil

    # --- Shell Scripting ---
    shfmt
    shellcheck

    # --- C / C++ Toolchain ---
    gcc
    libgcc
    gnumake
    cmake
    clang-tools
    valgrind
    cppcheck
    glslang
    gtest
    lcov
    codespell

    # --- Rust Toolchain ---
    rustc
    cargo
    rustfmt
    rust-analyzer

    # --- Haskell Toolchain ---
    ghc
    cabal-install
    haskell-language-server
    haskellPackages.hlint
    haskellPackages.stylish-haskell

    # --- Python & Web Core ---
    python3
    black
    nodejs
    yarn
    deno
    typescript-language-server

    sqlite
    sqlite-web
    sqlitecpp

    #android-tools
    #scrcpy
  ];
}
