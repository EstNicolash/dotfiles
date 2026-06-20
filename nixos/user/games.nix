{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    lutris
    bottles
    heroic

    # Envolva todo o bloco do override entre parênteses:
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        graalvmPackages.graalvm-ce
        zulu
      ];
    })

    brogue-ce
    azahar

    pcsx2
    dolphin-emu

    dualsensectl
  ];
}
