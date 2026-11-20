{
  config,
  inputs,
  lib,
  ...
}:
let
  pkgsFor =
    system:
    import inputs.nixpkgs {
      inherit system;
      config = import ../nixpkgs-config.nix;
    };
  darwinPkgs = pkgsFor "aarch64-darwin";
in
{
  flake = {
    formatter = lib.genAttrs [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ] (system: (pkgsFor system).nixfmt);

    # Keep the default personal home alongside both host-qualified profiles.
    homeConfigurations.brightone = config.flake.homeConfigurations."brightone@silicon";

    packages.aarch64-darwin = lib.filesystem.packagesFromDirectoryRecursive {
      inherit (darwinPkgs) callPackage;
      directory = ../packages;
    };

    checks.aarch64-darwin.configuration =
      let
        result = import ../tests/configuration.nix inputs.self;
      in
      assert result.silicon && result.iridium;
      darwinPkgs.runCommand "configuration-check" { } "touch $out";

    darwinModules.keyboard = import ./_darwin/keyboard.nix;
  };
}
