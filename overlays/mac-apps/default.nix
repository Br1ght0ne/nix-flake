{channels, ...}: final: prev: let
  pkgs = channels.nixpkgs;
in {
  brightone = {
    ice-bar = let
      version = "0.11.13-dev.2";
      hash = "sha256-wbuqcfYev+Xuko95CvYJY6nyAjZNY/eNLGs+xRBc9KA=";
    in
      if (builtins.compareVersions (pkgs.ice-bar.version) version) > 0
      then pkgs.ice-bar
      else
        pkgs.ice-bar.overrideAttrs (oldAttrs: {
          inherit version;
          src = pkgs.fetchurl {
            inherit (oldAttrs.src) url;
            inherit hash;
          };
        });
  };
}
