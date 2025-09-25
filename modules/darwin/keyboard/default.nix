{
  lib,
  config,
  ...
}: let
  cfg = config.system.keyboard;
in {
  options.system.keyboard = {
    nonUS.remapComparisonSigns = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether to remap the comparison signs key to backslack/pipe on non-us keyboards.";
    };
  };

  config = {
    system.keyboard.userKeyMapping = [
      (lib.mkIf cfg.nonUS.remapComparisonSigns {
        HIDKeyboardModifierMappingSrc = 30064771125;
        HIDKeyboardModifierMappingDst = 30064771121;
      })
    ];
  };
}
