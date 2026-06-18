{ pkgs, inputs, ... }:
let
  sandbox = inputs.agent-sandbox.lib.${pkgs.stdenv.hostPlatform.system};
  llm = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

  # Tools available on PATH inside every sandbox.
  # bash and cacert are always implicit (added by agent-sandbox.nix itself).
  commonPackages = with pkgs; [
    # Unix essentials
    coreutils
    findutils
    diffutils
    less
    which
    gnugrep
    gnused
    gawk
    curl
    git

    # Search / inspection
    fd
    ripgrep
    tree
    file # identify file types
    hexyl # hex viewer for binary inspection

    # Archives
    gzip
    xz
    zstd
    unzip

    # Data / query
    jq
    sqlite
    duckdb

    # GitHub CLI
    gh

    # Workspace management
    worktrunk

    # Benchmarking
    hyperfine

    # Python
    python3

    # JS / TS
    nodejs
    bun
    pnpm
    deno

    # Go
    go

    # Rust
    cargo
    rustc

    # C / C++ / build system
    stdenv.cc # clang wrapper with ar, ld, …
    gnumake
    cmake
    ninja
    pkg-config

    # Shell quality
    shellcheck
    shfmt

    # Spell-checking
    typos

    # Task runner / VCS
    just
    jujutsu

    # Nix
    nixfmt
    nurl # generate fetch expressions
    statix # linter
    deadnix # find unused bindings
    nixpkgs-hammering
  ];

  # Directories accessible (read-write) in every sandbox.
  # agent-sandbox.nix does not distinguish read-only vs read-write for
  # stateDirs; the full subtree is mounted read-write.
  commonStateDirs = [
    "$HOME/dev"
  ];

  claude = sandbox.mkSandbox {
    pkg = llm.claude-code;
    binName = "claude";
    outName = "claude";
    allowedPackages = commonPackages;
    rwDirs = commonStateDirs ++ [ "$HOME/.claude" ];
    env = {
      # Pass as a shell-variable reference so the value is never baked into
      # the Nix store; export it in the host shell before invoking the agent.
      CLAUDE_CODE_OAUTH_TOKEN = "$CLAUDE_CODE_OAUTH_TOKEN";
      # Keep claude's config inside the sandboxed ~/.claude stateDir so that
      # atomic renames don't cross mount boundaries (see agent-sandbox README).
      CLAUDE_CONFIG_DIR = "$HOME/.claude";
    };
  };

  claude-unboxed = pkgs.writeShellScriptBin "claude-unboxed" ''
    exec ${llm.claude-code}/bin/claude "$@"
  '';

  pi = sandbox.mkSandbox {
    pkg = llm.pi;
    binName = "pi";
    outName = "pi";
    allowedPackages = commonPackages;
    rwDirs = commonStateDirs ++ [ "$HOME/.pi" ];
    env = { };
  };

  pi-unboxed = pkgs.writeShellScriptBin "pi-unboxed" ''
    exec ${llm.pi}/bin/pi "$@"
  '';
in
{
  home.packages = [
    claude
    claude-unboxed
    pi
    pi-unboxed
  ];

  home.file = {
    # Sandbox instructions — shared by pi and Claude Code.
    # Describes accessible paths, tools on PATH, and usage examples.
    ".pi/agent/AGENTS.md" = {
      source = ./agents/AGENTS.md;
      force = true;
    };
    ".claude/CLAUDE.md" = {
      source = ./agents/AGENTS.md;
      force = true;
    };

    ".pi/agent/extensions" = {
      source = ./agents/pi/extensions;
      force = true;
    };

    # Pi settings: defaultProvider, defaultModel, enabledModels, skill overrides.
    # Read-only symlink — change settings here in the flake rather than via the TUI.
    ".pi/agent/settings.json" = {
      source = ./agents/pi/settings.json;
      force = true;
    };
    ".claude/settings.json" = {
      source = ./agents/claude/settings.json;
      force = true;
    };
  };
}
