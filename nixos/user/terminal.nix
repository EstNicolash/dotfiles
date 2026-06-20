{ config, pkgs, ... }:

{

  home.sessionPath = [
    "${config.home.homeDirectory}/.cache/npm/global/bin/"
    "${config.home.homeDirectory}/go/bin/"
  ];

  home.packages = with pkgs; [
    trashy
    bat
    fd
    ripgrep
    zoxide
    dust
    ouch
  ];

  programs.btop = {
    enable = true;
  };

  programs.fastfetch.enable = true;

  programs.gh = {
    enable = true;
    settings = {
      version = "1";
      aliases = {
        "as" = "auth status";
      };
    };
    gitCredentialHelper.enable = true;
    extensions = [ pkgs.gh-eco ];
  };

  programs.oh-my-posh = {
    enable = true;
    enableNushellIntegration = true;
    useTheme = "emodipt-extend";
  };

  programs.nushell = {
    enable = true;
    shellAliases = {
      sys-update = "nix flake update --flake ~/dotfiles/nixos/";
      sys-rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos/#nixos";
      home-rebuild = "home-manager switch --flake ~/dotfiles/nixos/#nan";
      sys-upgrade = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos/#nixos --upgrade";

      gon = "cd ~/dotfiles/nixos/";
      goc = "cd ~/Code/";
    };
    extraEnv = ''
      $env.PATH = ($env.PATH | prepend "${config.home.homeDirectory}/go/bin" | prepend "${config.home.homeDirectory}/.cache/npm/global/bin")
    '';
  };

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    dotDir = "${config.xdg.configHome}/zsh";

    history.size = 10000;

    shellAliases = {
      rm = "trash";
      ll = "ls -l";

      sys-update = "nix flake update --flake ~/dotfiles/nixos/";
      sys-rebuild = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos/#nixos";
      home-rebuild = "home-manager switch --flake ~/dotfiles/nixos/#nan";
      sys-upgrade = "sudo nixos-rebuild switch --flake ~/dotfiles/nixos/#nixos --upgrade";

      gon = "cd ~/dotfiles/nixos/";
      goc = "cd $HOME/Code";
    };

    oh-my-zsh = {
      enable = true;
      theme = "norm";
      plugins = [
        "git"
        "thefuck"
        "gh"
        "sudo"
        "vi-mode"
      ];
    };
  };
}
