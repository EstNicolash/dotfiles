# ==============================================================================
# Multimedia, Streaming & Recording (nixos/user/media.nix)
#
# Configures MPV video player (with Wayland/VA-API hardware decoding & MPRIS),
# OBS Studio with clean PipeWire/Vulkan capture plugins, Rust-based GTK4 audio
# playback (Amberol), audio editing (Tenacity), and yt-dlp.
# ==============================================================================
{ pkgs, ... }:

{
  # ----------------------------------------------------------------------------
  # OBS Studio (Wayland PipeWire & Vulkan Game Capture)
  # ----------------------------------------------------------------------------
  programs.obs-studio = {
    enable = true;
    plugins = with pkgs.obs-studio-plugins; [
      obs-pipewire-audio-capture
      obs-vkcapture
      obs-backgroundremoval
      obs-gstreamer
    ];
  };

  # ----------------------------------------------------------------------------
  # MPV Video Player (Wayland Native, Hardware Acceleration & Streaming Cache)
  # ----------------------------------------------------------------------------
  programs.mpv = {
    enable = true;
    defaultProfiles = [ "high-quality" ];
    scripts = with pkgs.mpvScripts; [ mpris ];

    config = {
      vo = "gpu-next";
      hwdec = "auto-safe";
      cache = "yes";
      demuxer-max-bytes = "1024MiB";
      demuxer-max-back-bytes = "512MiB";
      demuxer-readahead-secs = "300";
      ytdl-format = "bestvideo[height<=1080]+bestaudio/best[height<=1080]";
    };
  };

  # ----------------------------------------------------------------------------
  # Audio/Video Utilities & Rust GTK4 Music Player
  # ----------------------------------------------------------------------------
  home.packages = with pkgs; [
    yt-dlp
    tenacity
    amberol
  ];
}
