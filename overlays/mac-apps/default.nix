{ channels, ... }:
final: prev:
let
  pkgs = channels.nixpkgs;
in
{
  # Fix direnv build on Darwin: -linkmode=external is incompatible with CGO_ENABLED=0
  # on Go 1.26. Remove it until nixpkgs#503298 is merged.
  direnv = prev.direnv.overrideAttrs (oldAttrs: {
    postPatch =
      (oldAttrs.postPatch or "")
      + pkgs.lib.optionalString pkgs.stdenv.isDarwin ''
        substituteInPlace GNUmakefile --replace-fail '-linkmode=external' ""
      '';
  });

  brightone = {
    ice-bar =
      let
        version = "0.11.13-dev.2";
        hash = "sha256-wbuqcfYev+Xuko95CvYJY6nyAjZNY/eNLGs+xRBc9KA=";
      in
      if (builtins.compareVersions (pkgs.ice-bar.version) version) > 0 then
        pkgs.ice-bar
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
