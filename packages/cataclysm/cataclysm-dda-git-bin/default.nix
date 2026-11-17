{ callPackage }:
(callPackage ../common.nix { }).makeCddaPackage rec {
  pname = "cataclysm-dda-bin-git";
  timestamp = "2026-11-15-1800";
  version = "cdda-experimental-${timestamp}";
  hash = "sha256-lKbA/1OiIdh3qQYHA8ycudjRJFgLdyM6Du2Y2K4q+jQ=";
}
