{
  den.aspects.essential-apps.homeManager = { pkgs, ... }: {
    programs.emacs.enable = true;
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
      (pkgs.callPackage ../../packages/thaw { })
    ];
  };
  # Keep the native Telegram client; nixpkgs packages Telegram Desktop.
  den.aspects.essential-apps.darwin.homebrew.casks = [
    # macOS requires the real app in /Applications to activate its extensions.
    "protonvpn"
    "telegram"
  ];
}
