{
  den.aspects.work-dev = {
    homeManager = { pkgs, ... }: {
      home.packages = with pkgs; [
        rustc
        cargo
        nodejs
        bun
        linear
        (pkgs.callPackage ../../packages/gather-v2 { })
      ];
      programs.ripgrep.enable = true;
      programs.fd.enable = true;
      programs.grep.enable = true;
      programs.mise.enable = true;
    };
    # Zed and Telegram are provided by essential-apps on both hosts.
    darwin.homebrew.casks = [
      # brew bundle adopts an identical manually installed app automatically.
      "herdr-app"
      "chatgpt"
      "slack"
    ];
  };
}
