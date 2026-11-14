# Den migration

Status: approved. Plain Codex, a sandbox exploration TODO, and nixpkgs Node/Rust replacement explicitly confirmed.

## Final amendments

The implementation includes these later user decisions, superseding the original design below:

- `work-dev` is iridium-only; silicon keeps shared, personal, gaming and tiling aspects.
- Emacs, Linear and Ghostty come from nixpkgs. Gather V2 0.66.2 is packaged locally
  from the official universal DMG using `_7zz`, with its upstream signature preserved.
- All inputs were updated; Snowfall and my-packages were removed entirely. The
  used Cataclysm package was copied into this repository with provenance.
- A shared `nixpkgs-config.nix` enables unfree packages for system, home and package outputs.
- Global tools come from Nix; mise remains available for project-specific overrides.
- Iridium was built and activated after explicit approval. Silicon was evaluated
  without building its personal packages.
- At the user's request, duplicate Homebrew gh/git/mise/node/starship formulae and
  Codex/Emacs/Ghostty/Linear casks were removed after verifying active Nix replacements.
  App settings were preserved; Homebrew activation cleanup remains disabled.

## Intent

Replace Snowfall's configuration assembly with Den. Keep a small `brightone`
home identity and select reusable features for two aarch64-darwin hosts:
`silicon`, the existing personal Mac, and `iridium`, the new work Mac.
Preserve existing settings unless a split or addition below requires a change.

## Approaches

Considered plain dendritic flake-parts, flake-aspects, and Den. The user selected
Den to compose features across multiple machines and system/home scopes.
Use Den with a thin flake entry point and feature modules. The implementer may
choose explicit imports or import-tree and whether flake-parts adds value;
do not introduce generated flake files or another dependency pinning system.

## Feature selection

| Aspect | silicon | iridium | Contents |
| --- | --- | --- | --- |
| brightone | yes | yes | User/home identity and state version |
| system | yes | yes | Existing Darwin defaults, keyboard module, Determinate Nix compatibility |
| shell | yes | yes | Existing shell settings and utilities |
| terminal | yes | yes | Ghostty package and configuration from Nix |
| nix-tools | yes | yes | Existing Nix tools, nh, formatter and nix-index integration |
| vcs | yes | yes | Existing VCS configuration |
| editors | yes | yes | Existing editor configuration, including disabled Zed HM configuration |
| ai-agents | yes | yes | Claude, Pi, their assets, and newly added Codex CLI |
| sync | yes | yes | Existing Syncthing configuration |
| essential-apps | yes | yes | Homebrew casks emacs-app, raycast, telegram, zed |
| personal-dev | yes | no | Existing large home.packages list, except gaming and overlapping work tools |
| gaming | yes | no | Existing games.nix, nethack and gaming casks |
| personal-apps | yes | no | Remaining existing Homebrew casks and all existing MAS apps |
| window-management | yes | no | Existing Paneru configuration |
| work-dev | yes | yes | Requested work tools and apps |

The shared shell, editors, VCS and sync choices follow “everything else in
brightone can stay.” They are moved into aspects without opportunistic cleanup.
The initial personal-dev aspect is deliberately broad; finer classification can
follow later. `brightone` itself stays small, with host-selected feature aspects
providing the remaining home configuration. Host feature selection must reach the
Home Manager user through Den's supported routing, not just the Darwin scope.

`silicon` selects all features, as requested. Its existing package/app coverage
must remain, aside from deliberate toolchain consolidation below.

## Work tools and applications

Use nixpkgs rustc, cargo, ripgrep, fd, gnugrep, nodejs, bun and mise. Reuse existing
Home Manager programs options where present. Proposed implementation choice:
replace the old nodejs_22 and rustup entries with the work aspect's Node and Rust
packages on both hosts to avoid conflicting executables. Keep pnpm personal-only.
No language toolchain version was requested beyond the pinned nixpkgs versions.

Work casks: zed, herdr-app, chatgpt, slack, linear and telegram. Zed and Telegram
overlap essential-apps and must appear once in the resolved list. Ghostty remains
Nix-managed on both hosts; do not add its cask.

Inventory on iridium found exactly four existing-config cask matches:
emacs-app, raycast, telegram and zed. Existing configured formulae are empty, so
there are no formula matches. Other manually installed packages remain unmanaged;
activation must not uninstall them. In particular do not automatically remove the
currently installed Ghostty or Codex casks as part of this migration.

Homebrew belongs to Darwin aspects, not a Home Manager module. Preserve disabled
automatic updates/upgrades and checksum requirements; explicitly use non-removing
cleanup behavior. Check the requested casks against that policy during validation.
The locally installed herdr formula is distinct from the requested herdr-app cask.

## AI agents

Keep existing Claude/Pi packages, sandbox wrappers, unboxed commands, settings and
extensions on both hosts. Add Codex CLI using the existing llm-agents input if its
pinned revision provides a compatible package. Default implementation choice:
install the plain Codex CLI initially, without nesting another agent-sandbox
wrapper around it. Do not overwrite the user's existing ~/.codex configuration,
credentials, plugins or instructions. Adding the CLI does not authorize importing
local personal credentials or settings into the repository. No Codex desktop app
management is added. Any shared instructions must accurately describe the runtime
they are installed for; do not reuse the outer-sandbox instructions for plain Codex.

## Layout and compatibility

Place Den host declarations and aspects under modules/, with assets and legacy
ordinary modules outside automatic aspect discovery (or explicitly excluded).
Preserve relative asset references when moving files. Keep custom keyboard options
and wire the module explicitly; Snowfall auto-discovery will no longer provide it.

Preserve darwinConfigurations.silicon and add darwinConfigurations.iridium. Both
integrate the brightone home. Retain home stateVersion 26.05 and Darwin stateVersion
6. Set hostnames so nh selects the intended host; document explicit host selection
for first activation before the machine has been renamed. Preserve a standalone
home output if the existing evaluated flake exposes one, without accidentally
choosing a personal profile for the work host.

Keep the flake path used by nh correct after moving modules. Preserve formatter
outputs and relevant public module outputs. Inspect baseline outputs before edits.
Keep existing input pins wherever possible. Remove Snowfall configuration
assembly, but retain snowfall-lib if my-packages still follows it. Remove the
unused snowfall-flake overlay only after confirming it contributes no installed
packages. Keep llm-agents on its own nixpkgs pin.

Update AGENTS.md to describe Den, feature selection and both hosts.

## Validation and delivery

Capture existing evaluated settings/outputs before edits. Evaluate both hosts,
checking package selection, cask deduplication, no Paneru/personal-dev/gaming on
iridium, agents on both, Home Manager routing, keyboard options, state versions,
asset sources and nh paths. Compare silicon's baseline with the intentional changes.
Run formatting and build both Darwin configurations without activation. Document
existing upstream build failures separately from migration failures.

Nix exists at /nix/var/nix/profiles/default/bin/nix but is absent from the current
shell PATH; nh is not installed in the usual profile paths on iridium. Use the
absolute Nix executable for initial verification and bootstrap via flake outputs.
Network/store operations may require normal environment approval.

This task prepares and verifies the configuration. Activation changes the live
machine and should be a separate explicit step after reviewing the built result.

## Research

- https://den.denful.dev/guides/from-flake-to-den/
- https://den.denful.dev/guides/home-manager/
- https://github.com/numtide/llm-agents.nix
- https://github.com/archie-judd/agent-sandbox.nix
- https://formulae.brew.sh/cask/herdr-app

## Non-goals

No package-wide upgrades, work Git identity invention, personal credentials
migration, removal of manually installed applications, or enabling previously
disabled editor features. No further fine-grained personal-tool taxonomy now.
