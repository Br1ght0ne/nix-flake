{
  den.aspects.work-dev = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        rustc
        cargo
        nodejs
        bun
        linear
        orbstack
        chatgpt
        slack
        (pkgs.callPackage ../../packages/gather-v2/package.nix { })
      ];
    };
  };
}
