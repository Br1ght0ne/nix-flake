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
  homePackages = h: map (p: p.pname or p.name) h.home.packages;
  commonHome =
    h:
    assert h.home.username == "brightone";
    assert h.home.stateVersion == "26.05";
    assert h.programs.emacs.enable;
    assert h.programs.google-chrome.enable;
    assert h.programs.zed-editor.enable && h.programs.zed-editor.defaultEditor;
    assert !h.programs.zed-editor.mutableUserSettings;
    assert !h.programs.zed-editor.mutableUserKeymaps;
    assert !h.programs.zed-editor.mutableUserTasks;
    assert !h.programs.zed-editor.mutableUserDebug;
    assert lib.all (has h.programs.zed-editor.extensions) [
      "nix"
      "zedokai"
    ];
    assert has (homePackages h) "nerd-fonts-monaspace";
    assert h.programs.zed-editor.userSettings.agent_servers."codex-acp".type == "registry";
    assert !(h.programs.zed-editor.userSettings ? context_servers);
    assert h.programs.nushell.settings.buffer_editor == "zeditor";
    assert !(has (homePackages h) "herdr");
    assert h.programs.codex.enable;
    assert h.programs.codex.mutableSettings;
    assert h.programs.codex.settings.model == "gpt-6.2-sol";
    assert h.programs.codex.settings.model_reasoning_effort == "medium";
    assert h.programs.codex.settings.features.hooks;
    assert !h.programs.codex.settings.memories.use_memories;
    assert !(h.home.file ? ".codex/config.toml");
    assert h.programs.claude-code.enable;
    assert h.programs.claude-code.package ? buildSpec;
    assert h.programs.claude-code.settings.defaultMode == "bypassPermissions";
    assert h.programs.pi-coding-agent.enable;
    assert h.programs.pi-coding-agent.package ? buildSpec;
    assert h.programs.pi-coding-agent.settings.defaultProvider == "github-copilot";
    assert h.programs.ghostty.enable;
    assert has h.programs.ghostty.settings.font-family "Monaspace Neon";
    assert lib.all (has (homePackages h)) [
      "just"
      "monaspace"
      "raycast"
      "proton-pass"
      "lmstudio"
    ];
    assert h.programs.nushell.loadSessionVariables;
    assert h.programs.ripgrep.enable && h.programs.fd.enable;
    assert h.programs.grep.enable && h.programs.mise.enable;
    assert h.programs.mise.globalConfig.tools == { };
    true;
  standaloneSilicon = f.homeConfigurations."brightone@silicon";
  standaloneIridium = f.homeConfigurations."brightone@iridium";
  common =
    c:
    assert c.system.stateVersion == 6;
    assert commonHome (home c);
    assert lib.hasSuffix "/opt/homebrew/bin:/opt/homebrew/sbin" c.environment.systemPath;
    assert (home c).programs.nh.flake == "/Users/brightone/dev/github.com/Br1ght0ne/nix-flake";
    assert lib.all (has (packages c)) [
      "claude"
      "pi"
      "claude-unboxed"
      "pi-unboxed"
      "codex-boxed"
    ];
    assert
      (lib.findFirst (p: (p.pname or p.name) == "codex-boxed") null (home c).home.packages) ? buildSpec;
    assert
      !((lib.findFirst (p: (p.pname or p.name) == "codex") null (home c).home.packages) ? buildSpec);
    assert lib.all (x: !(has (casks c) x)) [
      "lm-studio"
      "proton-pass"
      "ghostty"
      "emacs-app"
      "linear"
      "raycast"
      "zed"
      "chatgpt"
      "slack"
    ];
    assert c.system.keyboard.nonUS.remapComparisonSigns;
    assert c.homebrew.onActivation.cleanup == "none";
    assert lib.all (has (packages c)) [
      "codex"
      "raycast"
      "thaw"
    ];
    assert !(has (packages c) "rustup");
    assert has (casks c) "telegram";
    assert has (casks c) "protonvpn";
    assert !(has (packages c) "proton-vpn");
    assert builtins.length (casks c) == builtins.length (lib.unique (casks c));
    assert (home c).home.file."${(home c).home.homeDirectory}/.pi/agent/settings.json".force;
    assert builtins.pathExists (home c).programs.claude-code.context;
    true;
in
assert f.darwinConfigurations ? iridium;
assert common silicon && common iridium;
assert commonHome standaloneSilicon.config && commonHome standaloneIridium.config;
assert lib.all (has (homePackages standaloneSilicon.config)) [
  "nethack"
  "pnpm"
];
assert !(has (homePackages standaloneSilicon.config) "gather-v2");
assert lib.all (has (homePackages standaloneIridium.config)) [
  "rustc"
  "cargo"
  "nodejs"
  "bun"
  "linear"
  "orbstack"
  "chatgpt"
  "slack"
  "gather-v2"
];
assert lib.all (x: !(has (homePackages standaloneIridium.config) x)) [
  "nethack"
  "pnpm"
];
assert lib.all (has (packages iridium)) [
  "rustc"
  "cargo"
  "nodejs"
  "bun"
  "linear"
  "orbstack"
  "chatgpt"
  "slack"
  "gather-v2"
];
assert !(has (casks iridium) "herdr-app");
assert !(has (casks silicon) "herdr-app");
assert silicon.homebrew.taps == [ ] && iridium.homebrew.taps == [ ];
assert lib.all (x: !(has (casks silicon) x)) [
  "alt-tab"
  "codexbar"
  "discord"
  "google-chrome"
  "losslesscut"
  "lunar"
  "obsidian"
  "imhex"
  "shortcat"
  "tailscale-app"
  "thunderbird"
  "trex"
  "whatsapp"
  "font-cozette"
  "font-dejavu"
  "font-hack-nerd-font"
  "font-lilex-nerd-font"
  "font-monaspice-nerd-font"
  "font-monocraft"
];
assert !(silicon.homebrew.masApps ? Keymapp) && !(silicon.homebrew.masApps ? WhatsApp);
assert lib.all
  (
    h:
    assert h.programs.obsidian.enable && h.programs.thunderbird.enable && h.programs.discord.enable;
    lib.all (has (homePackages h)) [
      "alt-tab-macos"
      "codexbar"
      "discord"
      "google-chrome"
      "losslesscut"
      "lunar"
      "obsidian"
      "shortcat"
      "tailscale-gui"
      "thunderbird-bin"
      "trex"
      "whatsapp-for-mac"
      "keymapp"
      "cozette"
      "dejavu-fonts"
      "monocraft"
      "imhex"
    ]
  )
  [
    (home silicon)
    standaloneSilicon.config
  ];
assert lib.all
  (
    h:
    lib.all (x: !(has (homePackages h) x)) [
      "discord"
      "obsidian"
      "keymapp"
    ]
  )
  [
    (home iridium)
    standaloneIridium.config
  ];
assert !(has (packages silicon) "gather-v2");
assert silicon.services.paneru.enable;
assert has (packages silicon) "moonlight-qt";
assert !(has (casks silicon) "moonlight");
assert silicon.networking.hostName == "silicon";
assert iridium.networking.hostName == "iridium";
assert builtins.isString f.darwinConfigurations.silicon.system.drvPath;
assert builtins.isString f.darwinConfigurations.iridium.system.drvPath;
assert builtins.isString f.homeConfigurations."brightone@iridium".activationPackage.drvPath;
assert builtins.isString standaloneSilicon.activationPackage.drvPath;
assert
  f.homeConfigurations.brightone.activationPackage.drvPath
  == standaloneSilicon.activationPackage.drvPath;
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
