# ==============================================================================
# Flake Entry Point (nixos/flake.nix)
#
# Declarative root for both the NixOS system configuration (nixosConfigurations)
# and the standalone Home Manager environment (homeConfigurations).
# Pins upstream inputs to a unified nixpkgs instance to avoid duplicate store
# evaluations and exposes all inputs via specialArgs / extraSpecialArgs.
# ==============================================================================
{
  description = "NixOS & Home Manager Modular Configuration";

  # ----------------------------------------------------------------------------
  # Flake Inputs
  # ----------------------------------------------------------------------------
  inputs = {
    # Core package set & system management
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Custom CachyOS kernel (LTO + x86_64-v3)
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel";

    # Wayland compositor (Niri) & system-wide theming (Stylix)
    niri = {
      url = "github:epireyn/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dux Labs Desktop Suite
    dms = {
      url = "github:duxlabs-dev/dux-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dms-plugin-registry = {
      url = "github:duxlabs-dev/dux-plugin-registry";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dank-greeter = {
      url = "github:duxlabs-dev/dux-greeter";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dfiles = {
      url = "github:duxlabs-dev/dux-files";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dsearch = {
      url = "github:duxlabs-dev/dux-search";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dcal = {
      url = "github:duxlabs-dev/dux-calendar";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    dgop = {
      url = "github:duxlabs-dev/dux-gop";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Native console recompilation launcher
    recomplauncher = {
      url = "github:elripalda/RecompLauncher";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ----------------------------------------------------------------------------
  # Flake Outputs
  # ----------------------------------------------------------------------------
  outputs =
    { self, nixpkgs, ... }@inputs:
    {
      # System-level NixOS configuration
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/default/configuration.nix
          inputs.niri.nixosModules.niri
          inputs.stylix.nixosModules.stylix
        ];
      };

      # User-level standalone Home Manager configuration
      homeConfigurations.nan = inputs.home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages."x86_64-linux";
        extraSpecialArgs = { inherit inputs; };
        modules = [
          ./user/home.nix
          inputs.niri.homeModules.niri
          inputs.stylix.homeModules.stylix
          inputs.dms.homeModules.dank-material-shell
          inputs.dms.homeModules.niri
          inputs.dms-plugin-registry.homeModules.default
          inputs.dfiles.homeModules.dux-files
          inputs.dsearch.homeModules.dsearch
        ];
      };
    };
}
