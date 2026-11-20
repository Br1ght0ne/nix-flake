{
  config,
  den,
  inputs,
  lib,
  ...
}:
{
  imports = [ inputs.den.flakeOutputs.homeConfigurations ];

  systems = den.systems ++ [
    "aarch64-linux"
    "x86_64-linux"
  ];

  perSystem =
    { pkgs, system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        # Gather V2 is the only unfree package exported by this flake.
        config.allowUnfreePredicate = package: lib.getName package == "gather-v2";
      };

      formatter = pkgs.nixfmt;

      packages = lib.mkIf (system == "aarch64-darwin") (
        lib.filesystem.packagesFromDirectoryRecursive {
          inherit (pkgs) callPackage;
          directory = ../packages;
        }
      );

      checks = lib.mkIf (system == "aarch64-darwin") {
        configuration =
          let
            result = import ../tests/configuration.nix inputs.self;
          in
          assert result.silicon && result.iridium;
          pkgs.runCommand "configuration-check" { } "touch $out";
      };
    };

  flake = {
    # Keep the default personal home alongside both host-qualified profiles.
    homeConfigurations.brightone = config.flake.homeConfigurations."brightone@silicon";

    darwinModules.keyboard = import ./_system/_darwin/keyboard.nix;
  };
}
