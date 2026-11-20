# Evaluate with: nix eval --impure --json --expr
# 'import ./tests/configuration.nix (builtins.getFlake (toString ./.))'
f:
let
  lib = f.inputs.nixpkgs.lib;
  inherit (f) darwinConfigurations homeConfigurations;
  silicon = darwinConfigurations.silicon.config;
  iridium = darwinConfigurations.iridium.config;
  standaloneSilicon = homeConfigurations."brightone@silicon";
  standaloneIridium = homeConfigurations."brightone@iridium";
  home = c: c.home-manager.users.brightone;
  packageName = package: package.pname or package.name;
  packageNames = h: map packageName h.home.packages;
  caskNames = c: map (cask: cask.name) c.homebrew.casks;
  expectPresent =
    profile: kind: actual: expected:
    let
      missing = lib.subtractLists actual expected;
    in
    lib.assertMsg (missing == [ ]) "${profile} is missing ${kind} ${lib.concatStringsSep ", " missing}";
  expectAbsent =
    profile: kind: actual: unwanted:
    let
      unexpected = lib.intersectLists actual unwanted;
    in
    lib.assertMsg (
      unexpected == [ ]
    ) "${profile} has unexpected ${kind} ${lib.concatStringsSep ", " unexpected}";

  checkProfiles = check: profiles: lib.all lib.id (lib.mapAttrsToList check profiles);

  checkHome =
    profile: h:
    assert h.home.username == "brightone";
    assert h.home.stateVersion == "26.05";
    assert !(h.nixpkgs.config.allowUnfree or false);
    assert h.programs.emacs.enable;
    assert h.programs.google-chrome.enable;
    assert h.programs.zed-editor.enable && h.programs.zed-editor.defaultEditor;
    assert !h.programs.zed-editor.mutableUserSettings;
    assert !h.programs.zed-editor.mutableUserKeymaps;
    assert !h.programs.zed-editor.mutableUserTasks;
    assert !h.programs.zed-editor.mutableUserDebug;
    assert expectPresent profile "Zed extensions" h.programs.zed-editor.extensions [
      "nix"
      "zedokai"
    ];
    assert h.programs.zed-editor.userSettings.agent_servers."codex-acp".type == "registry";
    assert !(h.programs.zed-editor.userSettings ? context_servers);
    assert h.programs.nushell.settings.buffer_editor == "zeditor";
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
    assert builtins.elem "Monaspace Neon" h.programs.ghostty.settings.font-family;
    assert expectPresent profile "packages" (packageNames h) [
      "nerd-fonts-monaspace"
      "just"
      "monaspace"
      "raycast"
      "proton-pass"
      "lmstudio"
    ];
    assert expectAbsent profile "packages" (packageNames h) [ "herdr" ];
    assert h.programs.nushell.enable && h.programs.nushell.loadSessionVariables;
    assert h.programs.ripgrep.enable && h.programs.fd.enable;
    assert h.programs.grep.enable && h.programs.mise.enable;
    assert h.programs.mise.globalConfig.tools == { };
    true;

  checkDarwin =
    profile: c:
    let
      h = home c;
      packages = packageNames h;
      casks = caskNames c;
      findPackage = name: lib.findFirst (p: packageName p == name) null h.home.packages;
    in
    assert c.system.stateVersion == 6;
    assert !(c.nixpkgs.config.allowUnfree or false);
    assert c.programs.nushell.enable;
    assert lib.getName c.users.users.brightone.shell == "nushell";
    assert builtins.elem "/run/current-system/sw/bin/nu" c.environment.shells;
    assert lib.hasInfix "UserShell /run/current-system/sw/bin/nu"
      c.system.activationScripts.postActivation.text;
    assert c.system.keyboard.nonUS.remapComparisonSigns;
    assert lib.hasSuffix "/opt/homebrew/bin:/opt/homebrew/sbin" c.environment.systemPath;
    assert h.programs.nh.flake == "/Users/brightone/dev/github.com/Br1ght0ne/nix-flake";
    assert expectPresent profile "packages" packages [
      "claude"
      "pi"
      "claude-unboxed"
      "pi-unboxed"
      "codex-boxed"
      "codex"
      "thaw"
    ];
    assert (findPackage "codex-boxed") ? buildSpec;
    assert !((findPackage "codex") ? buildSpec);
    assert expectAbsent profile "packages" packages [
      "rustup"
      "proton-vpn"
    ];
    assert c.homebrew.onActivation.cleanup == "none";
    assert c.homebrew.taps == [ ];
    assert lib.lists.allUnique casks;
    assert expectPresent profile "Homebrew casks" casks [
      "telegram"
      "protonvpn"
    ];
    assert expectAbsent profile "Homebrew casks" casks [
      "herdr-app"
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
    assert h.home.file."${h.home.homeDirectory}/.pi/agent/settings.json".force;
    assert builtins.pathExists h.programs.claude-code.context;
    true;

  checkSiliconHome =
    profile: h:
    assert h.programs.obsidian.enable && h.programs.thunderbird.enable && h.programs.discord.enable;
    assert expectAbsent profile "packages" (packageNames h) [ "gather-v2" ];
    expectPresent profile "packages" (packageNames h) [
      "nethack"
      "pnpm"
      "moonlight-qt"
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
    ];

  checkIridiumHome =
    profile: h:
    assert expectAbsent profile "packages" (packageNames h) [
      "nethack"
      "pnpm"
      "discord"
      "obsidian"
      "keymapp"
    ];
    expectPresent profile "packages" (packageNames h) [
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

  siliconHomes = {
    "silicon integrated home" = home silicon;
    "silicon standalone home" = standaloneSilicon.config;
  };
  iridiumHomes = {
    "iridium integrated home" = home iridium;
    "iridium standalone home" = standaloneIridium.config;
  };
in
assert checkProfiles checkHome (siliconHomes // iridiumHomes);
assert checkDarwin "silicon integrated home" silicon;
assert checkDarwin "iridium integrated home" iridium;
assert checkProfiles checkSiliconHome siliconHomes;
assert checkProfiles checkIridiumHome iridiumHomes;

assert silicon.services.paneru.enable;
assert !(iridium.services.paneru.enable or false);
assert silicon.networking.hostName == "silicon";
assert iridium.networking.hostName == "iridium";
assert expectAbsent "iridium Darwin" "Homebrew casks" (caskNames iridium) [ "heroic" ];
assert iridium.homebrew.masApps == { };
assert !(silicon.homebrew.masApps ? Keymapp) && !(silicon.homebrew.masApps ? WhatsApp);
assert expectAbsent "silicon Darwin" "Homebrew casks" (caskNames silicon) [
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
  "moonlight"
];

assert builtins.isString darwinConfigurations.silicon.system.drvPath;
assert builtins.isString darwinConfigurations.iridium.system.drvPath;
assert builtins.isString standaloneSilicon.activationPackage.drvPath;
assert builtins.isString standaloneIridium.activationPackage.drvPath;
assert
  homeConfigurations.brightone.activationPackage.drvPath
  == standaloneSilicon.activationPackage.drvPath;
{
  silicon = true;
  iridium = true;
}
