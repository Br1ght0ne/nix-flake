# Evaluate with: nix eval --impure --json --expr
# 'import ./tests/configuration.nix (builtins.getFlake (toString ./.))'
f:
let
  lib = f.inputs.nixpkgs.lib;
  silicon = f.darwinConfigurations.silicon.config;
  iridium = f.darwinConfigurations.iridium.config;
  home = c: c.home-manager.users.brightone;
  packages = c: map (p: p.pname or p.name) (home c).home.packages;
  casks = c: map (p: p.name) c.homebrew.casks;
  has = xs: x: builtins.elem x xs;
  common =
    c:
    assert c.system.stateVersion == 6;
    assert (home c).home.stateVersion == "26.05";
    assert (home c).home.username == "brightone";
    assert (home c).programs.ghostty.enable;
    assert (home c).programs.nushell.loadSessionVariables;
    assert (home c).programs.mise.globalConfig.tools == { };
    assert lib.hasSuffix "/opt/homebrew/bin:/opt/homebrew/sbin" c.environment.systemPath;
    assert (home c).programs.nh.flake == "/Users/brightone/dev/github.com/Br1ght0ne/nix-flake";
    assert lib.all (has (packages c)) [
      "claude"
      "pi"
      "claude-unboxed"
      "pi-unboxed"
    ];
    assert lib.all (x: !(has (casks c) x)) [
      "ghostty"
      "emacs-app"
      "linear"
    ];
    assert c.system.keyboard.nonUS.remapComparisonSigns;
    assert c.homebrew.onActivation.cleanup == "none";
    assert lib.all (has (packages c)) [
      "codex"
      "emacs"
    ];
    assert !(has (packages c) "rustup");
    assert lib.all (has (casks c)) [
      "raycast"
      "zed"
      "telegram"
    ];
    assert builtins.length (casks c) == builtins.length (lib.unique (casks c));
    assert builtins.pathExists (home c).home.file.".pi/agent/settings.json".source;
    assert builtins.pathExists (home c).home.file.".claude/CLAUDE.md".source;
    true;
in
assert f.darwinConfigurations ? iridium;
assert common silicon && common iridium;
assert (home iridium).programs.ripgrep.enable && (home iridium).programs.fd.enable;
assert (home iridium).programs.grep.enable && (home iridium).programs.mise.enable;
assert lib.all (has (packages iridium)) [
  "rustc"
  "cargo"
  "nodejs"
  "bun"
  "linear"
  "gather-v2"
];
assert lib.all (has (casks iridium)) [
  "chatgpt"
  "slack"
  "herdr-app"
];
assert !(has (packages silicon) "gather-v2");
assert silicon.services.paneru.enable;
assert silicon.networking.hostName == "silicon";
assert iridium.networking.hostName == "iridium";
assert builtins.isString f.darwinConfigurations.silicon.system.drvPath;
assert builtins.isString f.darwinConfigurations.iridium.system.drvPath;
assert builtins.isString f.homeConfigurations."brightone@iridium".activationPackage.drvPath;
assert f.homeConfigurations.brightone.config.programs.ghostty.enable;
assert !(iridium.services.paneru.enable or false);
assert has (packages silicon) "nethack";
assert !(has (packages iridium) "nethack");
assert !(has (packages iridium) "pnpm");
assert !(has (casks iridium) "heroic");
assert iridium.homebrew.masApps == { };
{
  silicon = true;
  iridium = true;
}
