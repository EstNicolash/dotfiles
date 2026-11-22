# ==============================================================================
# Gaming, Emulation & Native Recompilations (nixos/user/games.nix)
#
# Configures game launchers (Heroic, PrismLauncher, UMU), precision console
# emulators, native PC recompilations (RecompLauncher), Wayland compositing
# & performance overlays (Gamescope, MangoHud), and DualSense utilities.
# ==============================================================================
{ pkgs, inputs, ... }:

{


  programs.mangohud = {
    enable = true;
    settings = {
      fps_limit = [ 120 175 60 0 ];
      toggle_fps_limit = "Shift_R+F1";
      no_display = true;
    };
  };

  home.packages = with pkgs; [
    # Game launchers & Wine/Proton runtime bridge
    heroic
    umu-launcher
    cartridges
    protonup-rs

    # Minecraft launcher with dedicated JDKs
    (prismlauncher.override {
      additionalPrograms = [ ffmpeg ];
      jdks = [
        graalvmPackages.graalvm-ce
        zulu
        zulu17
      ];
    })

    # Native PC recompilations & classic roguelikes
    inputs.recomplauncher.packages.${pkgs.stdenv.hostPlatform.system}.default
    brogue-ce

    # Console emulators
    azahar
    dolphin-emu
    pcsx2
    bsnes-hd
    mesen
    mgba
    sameboy

    # Wayland game isolation, performance overlay & controller utilities
    gamescope
    mangohud
    dualsensectl
  ];
}
