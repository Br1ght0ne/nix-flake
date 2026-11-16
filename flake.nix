{
  description = "Everything Nix from Br1ght0ne";

  # Binary cache documented by llm-agents.nix (including Darwin Codex builds).
  nixConfig = {
    extra-substituters = [ "https://cache.numtide.com" ];
    extra-trusted-public-keys = [ "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g=" ];
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    den.url = "github:denful/den";

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

    agent-sandbox = {
      url = "github:archie-judd/agent-sandbox.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Provides up-to-date AI agent packages (claude-code, pi, …).
    # Intentionally not following nixpkgs — llm-agents pins its own nixpkgs
    # per agent to ensure builds work.
    llm-agents.url = "github:numtide/llm-agents.nix";

    paneru = {
      url = "github:karinushka/paneru";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    concord = {
      url = "github:chojs23/concord";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      pkgsFor =
        system:
        import inputs.nixpkgs {
          inherit system;
          config = import ./nixpkgs-config.nix;
        };
      config =
        (inputs.nixpkgs.lib.evalModules {
          modules = [ ./modules ];
          specialArgs = { inherit inputs; };
        }).config;
      systems = [
        "aarch64-darwin"
        "aarch64-linux"
        "x86_64-darwin"
        "x86_64-linux"
      ];
    in
    config.flake
    // {
      formatter = inputs.nixpkgs.lib.genAttrs systems (system: (pkgsFor system).nixfmt);
      # Keep the old personal-home name and expose explicit profiles for both hosts.
      homeConfigurations = config.flake.homeConfigurations // {
        brightone = config.flake.homeConfigurations."brightone@silicon";
      };
      packages.aarch64-darwin.cataclysm-dda-git-bin =
        (pkgsFor "aarch64-darwin").callPackage ./packages/cataclysm/cataclysm-dda-git-bin
          { };
      packages.aarch64-darwin.gather-v2 = (pkgsFor "aarch64-darwin").callPackage ./packages/gather-v2 { };
      packages.aarch64-darwin.orca = (pkgsFor "aarch64-darwin").callPackage ./packages/orca { };
      packages.aarch64-darwin.thaw = (pkgsFor "aarch64-darwin").callPackage ./packages/thaw { };
      checks.aarch64-darwin.configuration =
        let
          result = import ./tests/configuration.nix inputs.self;
        in
        assert result.silicon && result.iridium;
        (pkgsFor "aarch64-darwin").runCommand "configuration-check" { } "touch $out";
      darwinModules.keyboard = import ./modules/_darwin/keyboard.nix;
    };
}
