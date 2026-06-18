{ inputs, pkgs, ... }:
let
  my-pkgs = inputs.my-packages.packages.${pkgs.stdenv.hostPlatform.system};
in
{
  home.packages = with my-pkgs; [
    # cataclysm-dda-bin
    cataclysm-dda-git-bin
  ];
}
