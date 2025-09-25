{
  description = "Everything Nix from Br1ght0ne";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # The name "snowfall-lib" is required due to how Snowfall Lib processes your
    # flake's inputs.
    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs:
    inputs.snowfall-lib.mkFlake {
      inherit inputs;
      src = ./.;

      # Configure Snowfall Lib, all of these settings are optional.
      snowfall = {
        # Choose a namespace to use for your flake's packages, library,
        # and overlays.
        namespace = "brightone";

        # Add flake metadata that can be processed by tools like Snowfall Frost.
        meta = {
          # A slug to use in documentation when displaying things like file paths.
          name = "brightone-flake";

          # A title to show for your flake, typically the name.
          title = "Everything Nix from Br1ght0ne";
        };
      };

      overlays = with inputs; [
        snowfall-flake.overlays."package/flake"
      ];

      # Add modules to all homes.
      homes.modules = with inputs; [
        nix-index-database.homeModules.nix-index
      ];

      # The outputs builder receives an attribute set of your available NixPkgs channels.
      # These are every input that points to a NixPkgs instance (even forks). In this
      # case, the only channel available in this flake is `channels.nixpkgs`.
      outputs-builder = channels: {
        # Outputs in the outputs builder are transformed to support each system. This
        # entry will be turned into multiple different outputs like `formatter.x86_64-linux.*`.
        formatter = channels.nixpkgs.alejandra;
      };
    };
}
