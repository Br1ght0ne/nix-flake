{ den, ... }:
let
  nixpkgsConfig = import ../../nixpkgs-config.nix;
in
{
  den.default.darwin.nixpkgs.config = nixpkgsConfig;
  den.default.homeManager.nixpkgs.config = nixpkgsConfig;

  den.aspects.system.includes = [ den.batteries.hostname ];
  den.aspects.system.darwin = { lib, ... }: {
    imports = [ ../_darwin/keyboard.nix ];
    # Shared infrastructure for the apps that still need Homebrew.
    # GUI-launched Nushell loads this environment without path_helper.
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
    };
    home-manager = {
      # Use the same package policy for integrated and standalone homes.
      useGlobalPkgs = false;
      useUserPackages = true;
      backupFileExtension = "before-den";
    };
    nix.enable = false;
    system.stateVersion = 6;
    system.defaults = {
      menuExtraClock = {
        Show24Hour = true;
        ShowDate = 2; # never
        ShowDayOfWeek = false;
        ShowDayOfMonth = false;
      };
    };
    system.keyboard = {
      enableKeyMapping = true;
      remapCapsLockToEscape = true;
      nonUS.remapTilde = true;
      nonUS.remapComparisonSigns = true;
    };
  };
}
