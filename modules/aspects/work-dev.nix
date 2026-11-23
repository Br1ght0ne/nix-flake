{ den, ... }:
{
  den.aspects.work-dev = {
    includes = [
      (den.batteries.unfree [
        "chatgpt"
        "linear"
        "orbstack"
        "slack"
      ])
    ];

    homeManager = { pkgs, self', ... }: {
      home.packages = with pkgs; [
        rustc
        cargo
        nodejs
        bun
        google-cloud-sdk
        linear
        orbstack
        chatgpt
        slack
        self'.packages.gather-v2
      ];
    };
  };
}
