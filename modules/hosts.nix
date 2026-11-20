{ den, inputs, ... }:
{
  imports = [ inputs.den.flakeModule ];

  den.default.includes = with den.batteries; [
    self'
    inputs'
    flake-scope
  ];

  den.schema.user.classes = [ "homeManager" ];

  den.hosts.aarch64-darwin = {
    silicon.users.brightone = { };
    iridium.users.brightone = { };
  };

  den.homes.aarch64-darwin = {
    "brightone@silicon".aspect.includes = with den.aspects; [
      brightone
      silicon
    ];
    "brightone@iridium".aspect.includes = with den.aspects; [
      brightone
      iridium
    ];
  };

  den.aspects = {
    shared.includes = with den.aspects; [
      system
      shell
      vcs
      editors
      ai-agents
      essential-apps
    ];

    silicon.includes = with den.aspects; [
      shared
      personal-dev
      gaming
      personal-apps
      window-management
    ];

    iridium.includes = with den.aspects; [
      shared
      work-dev
    ];
  };
}
