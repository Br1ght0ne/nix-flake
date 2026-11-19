{
  den.aspects.work-dev = {
    homeManager = { pkgs, ... }: {
      programs.google-chrome.enable = true;
      home.packages = with pkgs; [
        rustc
        cargo
        nodejs
        bun
        linear
        orbstack
        chatgpt
        slack
        (pkgs.callPackage ../../packages/gather-v2 { })
      ];
    };
  };
}
