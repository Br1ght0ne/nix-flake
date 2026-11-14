{
  den.aspects.essential-apps.homeManager = { pkgs, ... }: { home.packages = [ pkgs.emacs ]; };
  den.aspects.essential-apps.darwin = { lib, ... }: {
    # GUI-launched Nushell loads system.build.setEnvironment, not path_helper.
    # Keep Nix-managed tools ahead of equivalent Homebrew installations.
    environment.systemPath = lib.mkAfter [
      "/opt/homebrew/bin"
      "/opt/homebrew/sbin"
    ];
    homebrew = {
      enable = true;
      onActivation = {
        autoUpdate = false;
        upgrade = false;
        cleanup = "none";
      };
      caskArgs.require_sha = true;
      casks = [
        "raycast"
        "telegram"
        "zed"
      ];
    };
  };
}
