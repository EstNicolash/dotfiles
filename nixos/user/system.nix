{
  pkgs,
  lib,
  config,
  ...
}:

{
  programs.zathura = {
    enable = true;
    options = {
      recolor = true;
      recolor-darkcolor = lib.mkForce "#282828";
      recolor-lightcolor = lib.mkForce "#d5c4a1";
      window-title-basename = lib.mkForce "true";
      selection-clipboard = lib.mkForce "clipboard";
      recolor-keephue = lib.mkForce true;
    };
  };

  programs.mpv = {
    enable = true;
    defaultProfiles = [ "gpu-hq" ];
    scripts = with pkgs.mpvScripts; [ mpris ];
  };

  programs.kitty = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.rclone.enable = true;

  xdg = {
    enable = true;
    mimeApps = {
      enable = true;
      defaultApplications = {
        "text/plain" = [ "zed.desktop" ];
        "application/pdf" = [ "org.pwmt.zathura.desktop" ];
        "x-scheme-handler/discord" = [ "vesktop.desktop" ];
        "x-scheme-handler/https" = [ "app.zen_browser.zen.desktop" ];
        "x-scheme-handler/http" = [ "app.zen_browser.zen.desktop" ];

        "image/jpeg" = [ "org.gnome.Loupe.desktop" ];
        "image/png" = [ "org.gnome.Loupe.desktop" ];
        "image/webp" = [ "org.gnome.Loupe.desktop" ];
        "image/gif" = [ "org.gnome.Loupe.desktop" ];

        "audio/mpeg" = [ "io.bassi.Amberol.desktop" ];
        "audio/mp4" = [ "io.bassi.Amberol.desktop" ];
        "audio/ogg" = [ "io.bassi.Amberol.desktop" ];
        "audio/wav" = [ "io.bassi.Amberol.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
      };
    };
  };

  home.packages = with pkgs; [
    xdg-utils
    shared-mime-info
    accountsservice

    vivaldi

    ## KDE
    kdePackages.dolphin
    kdePackages.systemsettings
    kdePackages.xdg-desktop-portal-kde
    kdePackages.filelight
    ffmpegthumbnailer
    kdePackages.ffmpegthumbs
    crow-translate
    qalculate-qt
    goldendict-ng

    qbittorrent
    cron
    wgnord
    dropbox-cli
    loupe
    swappy
    amberol

    libnotify
    wl-clipboard
    blueman
    networkmanagerapplet
    pavucontrol
    imagemagick

    gnupg1
    age
    wireguard-tools

    usbutils
    gphoto2
    kdePackages.kio-extras
  ];
}
