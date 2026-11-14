{
  den.aspects.system.darwin = {
    imports = [ ../_darwin/keyboard.nix ];
    nix.enable = false;
    system.stateVersion = 6;
    system.primaryUser = "brightone";
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
