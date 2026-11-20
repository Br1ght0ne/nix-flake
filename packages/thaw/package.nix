{ thaw, fetchurl }:

# TODO: Remove this override once the pinned nixpkgs includes
# https://github.com/NixOS/nixpkgs/pull/587990, and use pkgs.thaw directly.
thaw.overrideAttrs (
  finalAttrs: oldAttrs: {
    version = "2.1.0";
    src = fetchurl {
      url = "https://github.com/thaw-app/Thaw/releases/download/${finalAttrs.version}/Thaw_${finalAttrs.version}.zip";
      hash = "sha256-I/6FDda24/girwCi2nbG1GE1wvqKDe746PoJ0e/T7sE=";
    };
    meta = oldAttrs.meta // {
      description = "Open source menu bar manager for macOS";
      homepage = "https://github.com/thaw-app/Thaw";
    };
  }
)
