{ pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    lutris
    #   bottles
    heroic

    # Envolva todo o bloco do override entre parênteses:
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        graalvmPackages.graalvm-ce
        graalvmPackages.graalvm-oracle_17
        zulu
        zulu17
      ];
    })

    brogue-ce
    azahar

    pcsx2
    dolphin-emu
    umu-launcher

    dualsensectl
  ];
}
