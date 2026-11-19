{
  den.aspects.gaming.homeManager = { pkgs, ... }: {
    home.packages = [
      pkgs.nethack
      pkgs.moonlight-qt
      (pkgs.callPackage ../../packages/cataclysm/cataclysm-dda-git-bin { })
    ];
  };
  den.aspects.gaming.darwin.homebrew.casks = [
    "heroic"
    "parsec"
    "shattered-pixel-dungeon"
  ];
}
