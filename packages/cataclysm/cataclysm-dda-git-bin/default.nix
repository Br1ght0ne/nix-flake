{ callPackage }:
(callPackage ../common.nix { }).makeCddaPackage rec {
  pname = "cataclysm-dda-bin-git";
  timestamp = "2026-08-24-0428";
  version = "cdda-0.I-${timestamp}";
  hash = "sha256-QExG7fhCQDFTdLjeGYAlzHP+1vJmqXNExNc3G81xmgE=";
}
