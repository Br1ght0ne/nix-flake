{ den, ... }:
let
  shared = with den.aspects; [
    system
    shell
    terminal
    nix-tools
    vcs
    editors
    ai-agents
    sync
    essential-apps
  ];
in
{
  den.schema.user.classes = [ "homeManager" ];
  den.hosts.aarch64-darwin = {
    silicon.users.brightone = { };
    iridium.users.brightone = { };
  };
  den.homes.aarch64-darwin = {
    "brightone@silicon" = { };
    "brightone@iridium" = { };
  };
  den.aspects."brightone@silicon".includes = [ den.aspects.silicon ];
  den.aspects."brightone@iridium".includes = [ den.aspects.iridium ];
  den.aspects.silicon.includes =
    shared
    ++ (with den.aspects; [
      personal-dev
      gaming
      personal-apps
      window-management
    ]);
  den.aspects.iridium.includes = shared ++ [ den.aspects.work-dev ];
  den.default.darwin = { host, ... }: {
    nixpkgs.config = import ../nixpkgs-config.nix;
    networking.hostName = host.name;
    networking.localHostName = host.name;
    # Use the same package policy for integrated and standalone homes.
    home-manager.useGlobalPkgs = false;
    home-manager.useUserPackages = true;
    # Preserve unmanaged files during the first Home Manager activation.
    home-manager.backupFileExtension = "before-den";
  };
  den.default.homeManager.nixpkgs.config = import ../nixpkgs-config.nix;
}
