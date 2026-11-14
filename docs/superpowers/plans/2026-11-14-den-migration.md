# Den Migration Implementation Plan

> **For agentic workers:** Use superpowers:executing-plans to implement task-by-task.

**Goal:** Compose silicon and iridium from Den aspects, preserving shared home settings.
**Architecture:** A thin flake uses nixpkgs.lib.evalModules and Den with explicit module imports. Host profiles select aspects for Darwin and their brightone user.
**Tech Stack:** Nix, Den, nix-darwin, Home Manager, Homebrew.
**Spec:** ../specs/2026-11-14-den-migration-design.md (approved, including plain Codex and nixpkgs toolchains).

## Global Constraints

- aarch64-darwin hosts silicon and iridium, user brightone.
- home.stateVersion = "26.05"; system.stateVersion = 6.
- Activation and duplicate Homebrew removal were explicitly approved and completed.
- All input pins were updated at the user's request; llm-agents retains its own nixpkgs.
- Codex runs without an added sandbox; add a TODO to explore it.

## Review Focus

- Host aspects must reach Home Manager users as well as Darwin.
- Preserve agent assets and correct relative nh flake path.
- iridium must exclude personal packages, gaming and Paneru.
- Avoid Node/Rust executable conflicts and duplicate casks.
- Preserve silicon defaults and existing apps with non-removing Homebrew cleanup.

### Task 1: Baseline and Den integration

Files: flake.nix, flake.lock, modules/default.nix, modules/hosts.nix, tests/configuration.nix.
Produces: darwinConfigurations.silicon and iridium, host-aware home outputs.

- [x] Capture original output names and key resolved silicon settings in /private/tmp.
- [x] Add evaluation assertions for both hosts and observe missing iridium before migration.
- [x] Fetch Den source, inspect its pinned API and choose supported host/user routing.
- [x] Replace Snowfall assembly with Den and preserve required output compatibility.

### Task 2: Aspect extraction and host selection

Files: modules/aspects/*.nix, modules/hosts.nix, modules/_assets/, modules/_darwin/keyboard.nix.
Consumes: Den host/user routing from Task 1.
Produces: approved shared, personal and work feature selections.

- [x] Move existing settings into named Den aspects, retaining content and asset references.
- [x] Split Homebrew essentials, gaming and personal apps; add work casks without duplicates.
- [x] Install rustc/cargo/nodejs/bun through work-dev and remove old rustup/nodejs_22 entries.
- [x] Add plain llm-agents Codex and a sandbox exploration TODO.
- [x] Evaluate assertions for packages, casks, agents, Paneru, versions, keyboard mappings and asset paths.

### Task 3: Documentation, builds and review

Files: AGENTS.md, tests/configuration.nix, this plan.
Consumes: complete host configurations.

- [x] Document aspect selection and initial iridium build/switch commands.
- [x] Run Nix formatting, configuration evaluation and flake checks.
- [x] Build iridium; evaluate silicon only, as subsequently requested by the user.
- [x] Obtain a fresh code review and fix material findings with focused verification.
- [x] Record results and commit the reviewed changes on den-migration for the user.

## Execution record

Entries below are chronological. Final decisions are recorded in the design's
"Final amendments" section and in AGENTS.md; they supersede earlier preview states.

- Branch den-migration created in the shared checkout; implementation proceeds here to keep changes visible to the user.
- Nix requires cache/store access outside the sandbox; evaluation authorization requested through the execution tool.
- User explicitly approved plain Codex, a sandbox TODO, and nixpkgs Node/Rust replacement.

- Evaluation: both host assertions and all standalone home derivations pass; flake check --no-build passes.
- Baseline: silicon retains all original casks and package names except rustup; adds rustc, cargo, bun, codex and four work casks. Node now comes from nixpkgs nodejs rather than nodejs_22.
- Build correction: combined silicon/iridium build stopped at user's request; Concord was silicon-only. Remaining execution focuses on iridium via nh darwin switch --ask.
- Ruling: explicit imports and native Den standalone homes avoid additional flake assembly dependencies.
- Ruling: nh uses the live checkout path instead of a source-store path, so future switches see edits.
- Review: no critical/important defects. Deferred minors: strengthen standalone iridium exclusion tests and compare Node derivation paths rather than package names.
- Homebrew metadata: all eight iridium casks have concrete checksums; only herdr-app is not already installed as a cask.
- Current machine is future iridium. User requires nh switch --ask and reviewing diff/download size before activation.

- User requested updating all flake inputs; completed. Codex 0.169.0, Claude 2.1.325, Pi 1.5.2.
- User requested copying used my-packages definitions locally; copied only experimental Cataclysm package and helper with provenance. Removed my-packages and all Snowfall lock nodes.
- Updated Home Manager option names while preserving behavior; removed nixpkgs-removed rye (uv already enabled).
- Added publisher cache configuration; daemon does not trust user-provided caches on this Mac. User imported signed Codex package using sudo nix copy; binary version verified.
- Initial activation preflight: existing .zshrc and .config/gh/config.yml need backups. Set home-manager.backupFileExtension to before-den. Existing Claude settings remain explicitly force-managed and will be replaced if activated.

- User requested inspecting existing local preferences: retained gh co alias and optional LM Studio path; left existing local Git identity untouched. User explicitly chose to leave peon-ping out.
- User requires Nix global tools and mise only for project overrides: declared empty mise global tools table, retaining Nix yt-dlp and mise shell integration. Existing global mise config will be backed up.
- nh 4.4.2 built iridium successfully after all input updates; no current nix-darwin generation existed for a package diff. Declined its apply prompt to incorporate final local preference changes; rerunning before handoff.

- User requested removing unnecessary PATH workarounds. Replaced manual Nushell bootstrap with Home Manager loadSessionVariables; appended Homebrew after generated Nix paths via mkAfter; removed stale toolchain overrides. Retained only guarded LM Studio and local Herdr launcher directories, appended last through shared session variables.
- Verified actual Nushell startup in a clean temporary HOME: Nix profiles, TLS cert path, Nix-before-Homebrew ordering, optional local paths and absence of stale toolchain overrides all pass.
- Final iridium build and updated flake checks pass; silicon evaluated only, not compiled. Configuration remains unapplied pending user review via nh --ask.

- User approved moving Emacs 31.1 and Linear 1.32.8 to nixpkgs, matching Homebrew versions. Remaining casks stay for freshness; no custom definitions added for these apps.
- Ruling: useGlobalPkgs=false keeps Den's per-home unfree predicate effective in both integrated and standalone homes; Linear alone is allowed. Regression assertions cover both profiles.
- Homebrew bundle already adds --adopt automatically; no custom adoption option is needed. Existing Herdr.app and cask versions both 0.1.15. Archive fetched and checksum verified without installation.
