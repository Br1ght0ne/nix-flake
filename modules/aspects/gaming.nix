{
  den.aspects.gaming.homeManager = { pkgs, self', ... }: {
    home.packages = [
      pkgs.nethack
      pkgs.moonlight-qt
      self'.packages.cataclysm-dda-git-bin
    ];
  };
  den.aspects.gaming.darwin.homebrew.casks = [
    "heroic"
    "parsec"
    "shattered-pixel-dungeon"
  ];
}
