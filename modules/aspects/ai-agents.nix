{ inputs, ... }: {
  den.aspects.ai-agents.homeManager =
    {
      pkgs,
      config,
      lib,
      ...
    }:
    let
      sandbox = inputs.agent-sandbox.lib.${pkgs.stdenv.hostPlatform.system};
      llm = inputs.llm-agents.packages.${pkgs.stdenv.hostPlatform.system};

      # Explicit preference allowlist: never import LM Studio's live JSON into
      # the store, since it also contains tokens and application-owned state.
      lmStudioSettings = {
        language = "en";
        developerMode = false;
        enableLocalService = false;
        autoLoadBundledLLM = true;
        userInterfaceComplexityLevel = 0;
        sidebar = {
          showButtonNames = false;
          monochromeSidebarIcons = true;
        };
        ui = {
          missionControlFullscreen = false;
          showModelFileNameInMyModels = false;
          configureLoadParamsBeforeLoad = false;
          alwaysOpenModelLoaderFromPicker = false;
          contextDisplayMode = "percentage";
          appNavigationBarPosition = "left";
          showTabStripScrollBar = false;
          tabStripFullStripStyle = false;
          openDownloadsPaneOnStartNewModelDownload = false;
        };
        modelLoadingGuardrails = {
          mode = "high";
          customThresholdBytes = 4294967296;
          alwaysAllowLoadAnyway = false;
        };
        defaultContextLength = {
          type = "custom";
          value = 8192;
        };
      };

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
        "$HOME/.agents"
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

      codex-boxed = sandbox.mkSandbox {
        # Disable Codex's inner sandbox only after entering the outer sandbox.
        # Keep its server in this process tree rather than reusing a host daemon.
        pkg = pkgs.writeShellScriptBin "codex" ''
          exec ${llm.codex}/bin/codex --no-daemon --dangerously-bypass-approvals-and-sandbox "$@"
        '';
        binName = "codex";
        outName = "codex-boxed";
        allowedPackages = commonPackages;
        rwDirs = commonStateDirs ++ [ "$HOME/.codex" ];
        env = {
          CODEX_HOME = "$HOME/.codex";
          OPENAI_API_KEY = "\${OPENAI_API_KEY:-}";
        };
      };

    in
    {
      home.packages = [
        # Keep Codex's default command unboxed for IDE integrations while the
        # outer sandbox still has hook and terminal compatibility issues.
        codex-boxed
        claude-unboxed
        pi-unboxed

        # orchestration
        pkgs.lmstudio
        (pkgs.callPackage ../../packages/orca { })
      ];

      # LM Studio needs a writable file. Merge only declared preferences using
      # Home Manager's atomic writer, preserving credentials and runtime state.
      home.activation.lmStudioSettings = lib.hm.dag.entryAfter [ "linkGeneration" ] (
        lib.hm.generators.mkImpureConfigMerger {
          inherit pkgs;
          format = "json";
          empty = "{}";
          path = "${config.home.homeDirectory}/.lmstudio/settings.json";
          staticSettings = (pkgs.formats.json { }).generate "lm-studio-preferences.json" lmStudioSettings;
          jqOperation = "$dynamic * $static";
          mode = "600";
        }
      );

      # Native modules own settings and shared instructions; retain our sandbox
      # packages rather than installing a second, unboxed command.
      programs.codex = {
        enable = true;
        package = llm.codex;
        context = ../_assets/agents/AGENTS.md;
        # Merge preferences while preserving app-managed integration paths,
        # authentication, project trust and plugin state.
        mutableSettings = true;
        settings = {
          model = "gpt-6.2-sol";
          model_reasoning_effort = "medium";
          service_tier = "default";
          tui.terminal_title = [ "thread-title" ];
          features = {
            hooks = true;
            memories = false;
            chronicle = false;
          };
          memories = {
            generate_memories = false;
            use_memories = false;
          };
        };
      };
      programs.claude-code = {
        enable = true;
        package = claude;
        context = ../_assets/agents/AGENTS.md;
        settings = {
          skipWorkflowUsageWarning = true;
          theme = "auto";
          skipDangerousModePermissionPrompt = true;
          defaultMode = "bypassPermissions";
        };
      };
      programs.pi-coding-agent = {
        enable = true;
        package = pi;
        context = ../_assets/agents/AGENTS.md;
        settings = {
          lastChangelogVersion = "0.75.4";
          defaultProvider = "github-copilot";
          defaultModel = "claude-sonnet-4.6";
          defaultThinkingLevel = "high";
          enabledModels = [
            "github-copilot/claude-opus-4.7"
            "github-copilot/claude-sonnet-4.6"
            "github-copilot/gpt-5-mini"
          ];
          skills = [
            "-skills/anthropic-skills/skills/algorithmic-art/SKILL.md"
            "-skills/anthropic-skills/skills/brand-guidelines/SKILL.md"
            "+skills/pi-skills/brave-search/SKILL.md"
            "-skills/anthropic-skills/skills/canvas-design/SKILL.md"
          ];
        };
      };

      home.file = {
        ".pi/agent/extensions" = {
          source = ../_assets/agents/pi/extensions;
          force = true;
        };
        # Preserve the existing force policy when native modules take ownership.
        "${config.home.homeDirectory}/.pi/agent/AGENTS.md".force = true;
        "${config.home.homeDirectory}/.pi/agent/settings.json".force = true;
        "${config.home.homeDirectory}/.claude/CLAUDE.md".force = true;
        "${config.home.homeDirectory}/.claude/settings.json".force = true;
      };
    };
}
