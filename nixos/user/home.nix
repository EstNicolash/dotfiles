{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./terminal.nix
    ./dev.nix

    ./desktop/dms.nix
    ./desktop/wm.nix
    ./desktop/theme.nix

    ./comm.nix
    ./media.nix
    ./study.nix
    ./system.nix
    ./games.nix
    ./backup.nix

  ];

  nixpkgs.config.allowUnfree = true;

  home.username = "nan";
  home.homeDirectory = "/home/nan";
  home.stateVersion = "25.05";

  programs.home-manager.enable = true;
}
