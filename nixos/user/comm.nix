# ==============================================================================
# Communication & Collaboration (nixos/user/comm.nix)
#
# Configures Vesktop (Wayland-native Discord client with PipeWire audio share,
# arRPC, and declarative Vencord plugins).
# ==============================================================================
{ pkgs, ... }:

{
  # ----------------------------------------------------------------------------
  # Vesktop (Declarative Vencord + Wayland/PipeWire Audio Share)
  # ----------------------------------------------------------------------------
  programs.vesktop = {
    enable = true;

    settings = {
      arRPC = true;
      checkUpdates = false;
      customTitleBar = false;
      disableMinSize = true;
      splashTheming = true;
      staticTitle = true;
      hardwareAcceleration = true;
      discordBranch = "canary";
    };

    vencord.settings = {
      autoUpdate = false;
      autoUpdateNotification = false;
      notifyAboutUpdates = false;
      useQuickCss = true;
      disableMinSize = true;

      plugins = {
        MessageLogger = {
          enabled = true;
          ignoreSelf = true;
        };
        AccountPanelServerProfile.enabled = true;
        AlwaysAnimate.enabled = true;
        AlwaysExpandRoles.enabled = true;
        BetterFolders.enabled = true;
        BetterRoleContext.enabled = true;
        BetterSessions.enabled = true;
        BetterSettings.enabled = true;
        BiggerStreamPreview.enabled = true;
        BlurNSFW.enabled = true;
        CallTimer.enabled = true;
        ClearURLs.enabled = true;
        CopyFileContents.enabled = true;
        CrashHandler.enabled = true;
        CtrlEnterSend.enabled = true;
        CustomRPC.enabled = true;
        Experiments.enabled = true;
        FakeNitro.enabled = true;
        FavoriteGifSearch.enabled = true;
        FixImagesQuality.enabled = true;
        ForceOwnerCrown.enabled = true;
        FriendsSince.enabled = true;
        FullSearchContext.enabled = true;
        FullUserInChatbox.enabled = true;
        GameActivityToggle.enabled = true;
        ImplicitRelationships.enabled = true;
        MemberCount.enabled = true;
        MessageClickActions.enabled = true;
        MessageLatency.enabled = true;
        MessageLinkEmbeds.enabled = true;
        NoMaskedUrlPaste.enabled = true;
        PermissionsViewer.enabled = true;
        petpet.enabled = true;
        PlatformIndicators.enabled = true;
        ReplyTimestamp.enabled = true;
        ReverseImageSearch.enabled = true;
        SecretRingToneEnabler.enabled = true;
        ServerInfo.enabled = true;
        ShowConnections.enabled = true;
        ShowHiddenChannels.enabled = true;
        StartupTimings.enabled = true;
        ThemeAttributes.enabled = true;
        TypingIndicator.enabled = true;
        TypingTweaks.enabled = true;
        UserVoiceShow.enabled = true;
        ValidUser.enabled = true;
        VoiceChatDoubleClick.enabled = true;
        ViewIcons.enabled = true;
        VencordToolbox.enabled = true;
        WebScreenShareFixes.enabled = true;
        WhoReacted.enabled = true;
      };
    };
  };

  # ----------------------------------------------------------------------------
  # Voice & Messaging Clients
  # ----------------------------------------------------------------------------
  home.packages = with pkgs; [
    teamspeak6-client
    teams-for-linux
    fractal
  ];
}
