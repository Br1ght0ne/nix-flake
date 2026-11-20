# nix-flake — agent guide

Personal and work macOS configuration using Den, nix-darwin and Home Manager.

## Layout

- `flake.nix` / `flake.lock`: inputs and Den evaluation.
- `modules/hosts.nix`: host declarations and feature selection.
- `modules/aspects/`: named Den aspects, containing `darwin`, `homeManager`, or both.
- `modules/aspects/brightone.nix`: minimal shared user/home identity.
- `modules/_darwin/keyboard.nix`: ordinary Darwin module, imported by the system aspect.
- `modules/_assets/agents/`: shared Codex/Claude/Pi instructions and Pi extensions.
- `modules/flake-outputs.nix`: formatter, packages, checks and compatibility exports.
- `import-tree` loads modules under `modules/`. Underscore-prefixed paths such as
  `_assets/` and `_darwin/` are imported explicitly.
- Hosts and homes are declared through Den; there are no `systems/` or `homes/`
  discovery directories. Aspects select packages explicitly.
- `tests/configuration.nix`: evaluated host selection assertions.
- `logs/`: freeform notes; not built.

Both hosts are aarch64-darwin with user `brightone` and include the `shared` aspect:

- `silicon`: personal Mac; shared, personal, gaming and tiling features, without work-dev.
- `iridium`: work Mac; shared essentials and work-dev, without personal-dev,
  personal-apps, gaming or Paneru.

`den.batteries.host-aspects` projects the selected host features into the user's
Home Manager configuration. Keep the shared and host-specific feature lists in
`modules/hosts.nix`.
`homeConfigurations.brightone` remains the personal profile; explicit standalone
profiles are `brightone@silicon` and `brightone@iridium`.

## Build and apply

From this checkout, build without activation:

```sh
nix build .#darwinConfigurations.iridium.system --no-link
nix build .#darwinConfigurations.silicon.system --no-link
```

For initial setup before `nh` is installed or the machine renamed, build the
intended host and then explicitly activate it when ready:

```sh
nix build .#darwinConfigurations.iridium.system
sudo ./result/sw/bin/darwin-rebuild switch --flake .#iridium
```

On future iridium, do not activate silicon. Activation is a separate step from
validation. If Nix is absent from PATH, its initial executable is
`/nix/var/nix/profiles/default/bin/nix`.

After setup, `nh darwin build` builds and `nh darwin switch` activates the current
host. `programs.nh.flake` points to the live checkout at
`~/dev/github.com/Br1ght0ne/nix-flake`; adjust that option if moving the repository.

## Features and packages

Add packages/settings to the appropriate aspect, then include the aspect on the
hosts that need it. Home Manager packages belong under `homeManager`; Homebrew
belongs under `darwin`. A feature may use both classes in the same file.
Default to nixpkgs when adding software. Use Homebrew only when explicitly
requested or when a suitable nixpkgs package is unavailable.
For GUI migrations, use upstream binary distributions or verify that the exact
Darwin output is available on `https://cache.nixos.org` before adopting a
source-built package. Recheck this when updating nixpkgs; do not assume cache
availability carries across pins. The cache preflight covers AltTab, Emacs,
ImHex, Moonlight, Sniffnet and Zed. Add new source-built GUI apps to
`scripts/gui-cache-paths.nix`. Nix may build small wrappers and configuration
files locally; it must not require compiling those GUI apps.

- `essential-apps`: Chrome, Raycast, Proton Pass, Thaw, rclone and Syncthing.
  Raycast starts at login through Home Manager launchd.
  The native macOS Telegram client remains on Homebrew (nixpkgs has Telegram Desktop).
  ProtonVPN also uses Homebrew: macOS requires its real app in `/Applications`
  to activate network extensions; the Home Manager location fails at runtime.
- `shell`: Nushell, Zsh, Ghostty with Monaspace, and shared CLI and Nix tools,
  including ripgrep, fd, GNU grep and mise.
- `editors`: Emacs, Helix, Neovim and Zed through Home Manager. Doom user files
  (`config.el`, `init.el`, `packages.el`) come from `modules/_assets/doom`; its
  checkout and package state remain unmanaged and writable. Zed uses the older
  declarative settings plus Codex ACP. Settings are immutable and must be edited
  in Nix; MCP servers are not configured. Do not put API keys in Nix settings.
- `work-dev`: nixpkgs Rust/Cargo, Node, Bun, Linear, OrbStack, ChatGPT, Slack
  and Gather V2.
- `ai-agents`: Home Manager Codex, Claude and Pi modules own instructions and
  settings. Claude/Pi retain their sandboxed packages and unboxed commands.
  Plain `codex` retains Codex's normal sandbox defaults. Home Manager merges
  model, reasoning, terminal-title, hook and memory preferences into writable
  local config, preserving IDE integration paths, plugin state and project trust.
  Opt-in `codex-boxed` uses
  `--no-daemon --dangerously-bypass-approvals-and-sandbox` inside the outer sandbox;
  its hook and terminal compatibility is unfinished. Orca and LM Studio
  are installed through Nix. LM Studio preferences are merged into its writable
  settings at activation; tokens and runtime state remain local. Quit LM Studio
  before switching to avoid concurrent writes. Shared instructions remain in
  `modules/_assets/agents/AGENTS.md`; Pi extensions remain ordinary source assets.
- `personal-dev`: the remaining broad personal package collection.
- `personal-apps`: Home Manager Discord, Obsidian and Thunderbird; supported native apps
  and fonts from nixpkgs. Remaining casks and Mac App Store apps are Darwin-only.
- `gaming`, `window-management`: silicon-only additions; Moonlight comes from Nix.

Homebrew auto-update and upgrade are disabled. Cleanup is `none`: manually
installed packages are not removed. Apps migrated to Nix may still have old
Homebrew copies; remove those only after activation and runtime verification.
Casks require checksums. No extra Homebrew taps are declared; Orca uses the local
Nix package, so the old `stablyai/orca` tap is unnecessary.

Remaining Brew exceptions are intentional: Calibre is marked broken on Darwin
at the current pin; Anki and Shattered Pixel Dungeon lack equivalent native app
bundles; Heroic and Parsec lack Darwin packages; the other retained casks have
no equivalent packaged native application at this pin. Do not replace Postgres.app,
Ollama.app or the native Telegram client with CLI-only or different clients merely
to reduce the cask count.

## Validation and formatting

After editing Nix files, format them with the flake's pinned formatter via
`nix fmt`. Do not use an arbitrary `nixfmt` from PATH or a hard-coded Nix store
path, since its version may differ from the repository's formatter.

```sh
nix fmt
nix eval --impure --json --expr 'import ./tests/configuration.nix (builtins.getFlake (toString ./.))'
nix flake check --no-build
```

Add new files to Git before evaluating a Git-backed flake; alternatively use
`path:.` while developing. Assertions check both host selections; builds validate
full system and home closures. Do not claim a successful build from evaluation alone.

## Inputs

`nixpkgs-config.nix` holds the shared nixpkgs policy (`allowUnfree = true`),
used by Den's Darwin/Home Manager defaults and the flake's package outputs.
Local packages can be built without `NIXPKGS_ALLOW_UNFREE` or `--impure`.

Keep existing pins unless an update is requested. Run `just update-nixpkgs` to
stage a nixpkgs-only update. It checks the exact `aarch64-darwin` GUI outputs on
`https://cache.nixos.org` and replaces `flake.lock` only after every lookup
passes. Run `just check-gui-cache` to check the current pin, including after
updating multiple inputs manually. Both recipes work on silicon and iridium.
The preflight evaluates paths and queries cache metadata without building
packages. Keep lockfile updates readable and separate unrelated upgrades from
configuration changes.

Den assembles all host and home configurations. Nixpkgs discovers local packages
from `packages/<name>/package.nix` and exports them under `packages.aarch64-darwin`.
`llm-agents` intentionally has its own nixpkgs pin. Other package
inputs follow the primary nixpkgs where configured. Paneru remains available for
silicon. Zed uses the default nixpkgs package through Home Manager.

Use `typos` for spelling checks; exceptions live in `.typos.toml`.

The agent publisher cache is declared in nixConfig. On an untrusted-user Nix
installation, accepting flake config alone does not grant daemon cache access;
use an administrator-approved cache configuration or signed store import.
First activation backs up unmanaged Home Manager targets with `.before-den`.
The existing force-managed Claude/Pi targets are exceptions and are replaced.

Nushell uses Home Manager's native session loader (`loadSessionVariables = true`).
Do not duplicate nix-daemon.sh in Nushell. Homebrew paths follow Nix paths;
LM Studio and local launcher directories are appended only when present.
Mise is available for project overrides, with an empty managed global tools table;
global tools such as yt-dlp are supplied by Nix.
