{
  config,
  lib,
  pkgs,
  ...
}:
let
  user = config.system.primaryUser;
  shellPath = "/run/current-system/sw${pkgs.nushell.shellPath}";
  userRecord = lib.escapeShellArg "/Users/${user}";
in
{
  # Den's user-shell battery sets this option, which nix-darwin lacks.
  options.programs.nushell.enable = lib.mkEnableOption "Nushell login shell integration";

  # nix-darwin installs the shell but only updates accounts it owns.
  config.system.activationScripts.postActivation.text =
    lib.mkIf
      (
        config.programs.nushell.enable
        && user != null
        && config.users.users.${user}.shell == pkgs.nushell
        && !builtins.elem user config.users.knownUsers
      )
      ''
        if currentUserShell=$(/usr/bin/dscl . -read ${userRecord} UserShell) &&
           [[ "$currentUserShell" != "UserShell: ${shellPath}" ]] &&
           [[ -x "$systemConfig/sw${pkgs.nushell.shellPath}" ]]; then
          /usr/bin/dscl . -create ${userRecord} UserShell ${lib.escapeShellArg shellPath}
        fi
      '';
}
