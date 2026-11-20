{ den, ... }:
{
  den.aspects.essential-apps.includes = [
    (den.batteries.unfree [
      "google-chrome"
      "raycast"
    ])
  ];

  den.aspects.essential-apps.homeManager = { pkgs, self', ... }: {
    programs.google-chrome.enable = true;
    programs.rclone.enable = true;
    services.syncthing.enable = true;

    # Replace the login item removed with the old Homebrew installation.
    launchd.agents.raycast = {
      enable = true;
      config = {
        ProgramArguments = [ "${pkgs.raycast}/Applications/Raycast.app/Contents/MacOS/Raycast" ];
        RunAtLoad = true;
      };
    };
    home.packages = [
      pkgs.raycast
      pkgs.proton-pass
      self'.packages.thaw
    ];
  };
  den.aspects.essential-apps.darwin.homebrew.casks = [
    # macOS requires the real app in /Applications to activate its extensions.
    "protonvpn"
    # Keep the native Telegram client; nixpkgs packages Telegram Desktop.
    "telegram"
  ];
}
