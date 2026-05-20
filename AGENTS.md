# nix-flake — agent guide

Personal macOS (aarch64-darwin) Nix configuration built on
[Snowfall Lib](https://github.com/snowfallorg/lib), managed with
[nix-darwin](https://github.com/nix-darwin/nix-darwin) and
[home-manager](https://github.com/nix-community/home-manager).

---

## Repo structure

```
flake.nix                          # Flake inputs & Snowfall Lib wiring
flake.lock                         # Pinned input revisions (generated)

homes/
  aarch64-darwin/
    brightone/
      default.nix                  # Home-manager root; home.packages list
      editors.nix                  # Helix, Neovim, Zed
      nix.nix                      # nh, nix-index, formatters, LSPs, helpers
      shell.nix                    # Shells (zsh, nushell), CLI tools via programs.*
      vcs.nix                      # git, jj, gh, lazygit, diff tools

systems/
  aarch64-darwin/
    silicon/
      default.nix                  # Top-level system imports
      aerospace.nix                # AeroSpace tiling WM config
      homebrew.nix                 # nix-darwin Homebrew integration (brews, casks, masApps)
      system.nix                   # macOS system defaults, keyboard remapping

modules/
  darwin/
    keyboard/
      default.nix                  # Custom nix-darwin module: nonUS comparison-sign remap

logs/                              # Freeform change-log notes (not Nix, not built)
```

Snowfall Lib auto-discovers systems and homes by directory path, so
`systems/aarch64-darwin/silicon` → the `silicon` darwin configuration, and
`homes/aarch64-darwin/brightone` → the `brightone` home-manager configuration.

---

## Applying the configuration

```sh
nh darwin switch
```

`nh` is configured in `homes/…/nix.nix` with
`programs.nh.flake = toString ../../..` pointing at the repo root, so no path
argument is needed.  `nh darwin switch` builds and activates both the
nix-darwin system layer and home-manager in one step, showing a diff of
changed packages before switching.

To do a dry run (build only, no activation):

```sh
nh darwin build
```

---

## Common workflows

### Adding a Nix package

1. Find the attribute name with `nix-search-tv` (in PATH) or
   `nix search nixpkgs <name>`.
2. Add it to the appropriate list in `homes/aarch64-darwin/brightone/default.nix`
   inside `home.packages` — or, if it needs `programs.*` options, put it in
   the relevant module (`shell.nix`, `editors.nix`, etc.).
3. Apply:

   ```sh
   nh darwin switch
   ```

### Adding a Homebrew cask / brew / Mac App Store app

Edit `systems/aarch64-darwin/silicon/homebrew.nix`:

- **Cask** → add to `homebrew.casks`
- **Brew formula** → add to `homebrew.brews`
- **Mac App Store** → add to `homebrew.masApps` as `"App Name" = <numeric-id>;`
- **Tap** → add to `homebrew.taps` if the formula/cask lives in a custom tap

Apply:

```sh
nh darwin switch
```

nix-darwin will call `brew bundle` during activation.  `onActivation.cleanup`
is set to `"check"` (warn about extra packages but don't remove them).

### Updating flake inputs

Update all inputs:

```sh
nix flake update
```

Update a single input (e.g. `nixpkgs`):

```sh
nix flake update nixpkgs
```

Both commands rewrite `flake.lock`.  After updating, apply and verify nothing
is broken:

```sh
nh darwin switch
```

Commit the lockfile separately from any config changes so the diff is
readable:

```sh
# example jj workflow
jj commit -m "nix flake update"
```

### Adding a new nix-darwin module

1. Create `modules/darwin/<name>/default.nix` with the usual
   `{ lib, config, ... }: { options = …; config = …; }` shape.
2. Snowfall Lib auto-loads modules from `modules/`, so no manual import is
   needed.
3. Enable / configure the module in the relevant system or home file.

### Reformatting Nix files

The formatter is `nixfmt` (set via `outputs-builder`):

```sh
nix fmt
```

### Spelling / typos

[typos](https://github.com/crate-ci/typos) is in the home packages.
Exceptions are in `.typos.toml` at the repo root.

```sh
typos          # check
typos --write-changes   # auto-fix
```

---

## Key inputs

| Input | Purpose |
|---|---|
| `nixpkgs` | `nixpkgs-unstable` — primary package set |
| `snowfall-lib` | Automatic system/home/module discovery |
| `darwin` | nix-darwin macOS system management |
| `home-manager` | User environment management |
| `nix-index-database` | Pre-built `nix-index` DB + `comma` |

All inputs follow `nixpkgs` (`inputs.X.follows = "nixpkgs"`) to avoid
duplicate nixpkgs instances in the closure.
