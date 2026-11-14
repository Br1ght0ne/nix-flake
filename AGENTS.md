# nix-flake — agent guide

Personal and work macOS configuration using Den, nix-darwin and Home Manager.

## Layout

- `flake.nix` / `flake.lock`: inputs, Den evaluation and compatibility outputs.
- `modules/hosts.nix`: host declarations and feature selection.
- `modules/aspects/`: named Den aspects, containing `darwin`, `homeManager`, or both.
- `modules/aspects/brightone.nix`: minimal shared user/home identity.
- `modules/_darwin/keyboard.nix`: ordinary Darwin module, imported by the system aspect.
- `modules/_assets/agents/`: shared Claude/Pi instructions, settings and extensions.
- `modules/default.nix`: explicit aspect imports. Add new aspect files here.
- `tests/configuration.nix`: evaluated host selection assertions.
- `logs/`: freeform notes; not built.

Both hosts are aarch64-darwin with user `brightone`:

- `silicon`: personal Mac; shared, personal, gaming and tiling features, without work-dev.
- `iridium`: work Mac; shared essentials and work-dev, without personal-dev,
  personal-apps, gaming or Paneru.

`den.batteries.host-aspects` projects the selected host features into the user's
Home Manager configuration. Keep feature selection in `modules/hosts.nix`.
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

- `essential-apps`: Emacs from Nix; Raycast, Telegram and Zed from Homebrew.
  These started from the intersection of iridium's installed casks and the old configuration.
- `work-dev`: nixpkgs Rust/Cargo, Node, Bun, ripgrep, fd, GNU grep and mise;
  Linear and Gather V2 from Nix; Homebrew Herdr, ChatGPT and Slack. Zed/Telegram come from essentials.
- `terminal`: Ghostty from Nix, including its settings.
- `ai-agents`: sandboxed Claude/Pi plus unboxed commands and plain Codex CLI.
  Codex sandboxing is a TODO. Existing local Codex settings are not managed.
- `personal-dev`: the remaining broad personal package collection.
- `gaming`, `personal-apps`, `window-management`: silicon-only additions.

Homebrew auto-update and upgrade are disabled. Cleanup is `none`: manually
installed packages are not removed. Existing Homebrew Ghostty/Codex installations
are not automatically uninstalled. Casks require checksums.

## Validation and formatting

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

Keep existing pins unless an update is requested. `nix flake update` updates all
inputs; `nix flake update INPUT` updates one. Keep lockfile updates readable and
separate unrelated upgrades from configuration changes.

Den replaces Snowfall entirely. Custom packages live under `packages/`: Cataclysm
and the official Gather V2 macOS binary. Neither my-packages nor snowfall-lib is an input. `llm-agents` intentionally has its own nixpkgs pin. Other package
inputs follow the primary nixpkgs where configured. Paneru remains available for
silicon. No nixpkgs-stable input is currently declared; the old disabled Zed HM
configuration retains a dormant reference to it and must be revisited before enabling.

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
