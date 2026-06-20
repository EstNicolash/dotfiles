{ inputs, pkgs, ... }:

{
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://attic.xuyh0120.win/lantian" ];
    trusted-public-keys = [ "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc=" ];
  };

  nixpkgs.overlays = [
    inputs.niri.overlays.niri
    inputs.nix-cachyos-kernel.overlays.pinned

    (final: prev: {
      openldap = prev.openldap.overrideAttrs (old: {
        doCheck = !prev.stdenv.hostPlatform.isi686;
      });
    })
  ];

}
