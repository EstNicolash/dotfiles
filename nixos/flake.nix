{
  description = "NixOS & Home Manager Modular Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    niri = {
      #url = "github:sodiboo/niri-flake";
      url = "github:sodiboo/niri-flake?rev=6bb99ff875919f03ea6054026619d999061e1170";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms = {
      url = "github:AvengeMedia/DankMaterialShell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";


    dank-greeter = {
        url = "github:AvengeMedia/dank-greeter";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, ... }@inputs:
    {

      # NixOS
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/lab210/configuration.nix
          inputs.niri.nixosModules.niri
          inputs.stylix.nixosModules.stylix
          #inputs.dank-greeter.nixosModules.default
        ];
      };

      # Home Manager
      homeConfigurations.nan = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./user/home.nix
          inputs.niri.homeModules.niri
          inputs.stylix.homeModules.stylix
          inputs.dms.homeModules.dank-material-shell
          inputs.dms.homeModules.niri
        ];
      };

    };
}
