# ==============================================================================
# System Gaming Runtime & Optimizations (nixos/system/games.nix)
#
# Configures privileged system-level gaming infrastructure: Steam with FHS
# compatibility, Gamescope micro-compositor, GameMode CPU/GPU governor tuning,
# and Mesa shader cache limits for AMD GPUs.
# User-space gaming tools (MangoHud, ProtonUp-rs, Protontricks, RecompLauncher)
# are managed in user/games.nix.
# ==============================================================================
{ pkgs, ... }:

{
  # ----------------------------------------------------------------------------
  # Steam, Gamescope & GameMode
  # ----------------------------------------------------------------------------
  programs = {
    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
    };

    gamescope = {
      enable = true;
      # Allow real-time thread priority adjustments for smoother frame pacing
      capSysNice = true;
    };

    gamemode.enable = true;
  };

  # ----------------------------------------------------------------------------
  # Graphics & Shader Cache Environment
  # ----------------------------------------------------------------------------
  # Increase Mesa shader cache limit (default 1GB) to prevent shader stutter
  environment.sessionVariables = {
    MESA_SHADER_CACHE_MAX_SIZE = "12G";
  };

  # ----------------------------------------------------------------------------
  # System-Level Compatibility Utilities
  # ----------------------------------------------------------------------------
  # Expose Steam's FHS runtime wrapper system-wide for standalone Linux binaries
  environment.systemPackages = with pkgs; [
    steam-run
  ];
}
