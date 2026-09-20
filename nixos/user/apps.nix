{ pkgs, ... }:

{

  home.packages = with pkgs; [
    #ferdium
    shiori
    microsoft-edge

  ];

}
