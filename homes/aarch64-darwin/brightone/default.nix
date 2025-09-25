{
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.nix-index-database.comma.enable = true;
  programs.zed-editor = {
    enable = true;
    extraPackages = with pkgs; [bash-language-server nil nixd];
    userSettings = {
      edit_predictions = {
        mode = "eager";
        copilot = {
          proxy = null;
          proxy_no_verify = null;
          enterprise_uri = null;
        };
        enabled_in_text_threads = false;
      };
      ssh_connections = [
        {
          host = "bazzite";
          username = "brightone";
          projects = [
            {
              paths = [
                "/home/brightone/code/syndicate-appchains"
              ];
            }
          ];
        }
      ];
      # helix_mode = true;
      vim_mode = true;
      ui_font_size = 14;
      buffer_font_size = 13;
      buffer_font_family = "MonaspiceNe Nerd Font";
      buffer_font_features = {
        calt = true;
        ss01 = true;
        ss02 = true;
        liga = true;
      };
      theme = "Zedokai Darker (Filter Spectrum)";
      terminal = {
        font_size = 12;
        line_height = "standard";
        option_as_meta = true;
        env = {
          EDITOR = "zed --wait";
        };
        shell = {
          program = "nu";
        };
      };
      agent = {
        default_profile = "ask";
        default_model = {
          provider = "copilot_chat";
          model = "claude-3.7-sonnet";
        };
      };
      features = {
        edit_prediction_provider = "zed";
      };
      use_smartcase_search = true;
      inlay_hints.enabled = true;
      languages = {
        Nix = {
          language_servers = [
            "nixd"
            "nil"
          ];
        };
      };
      lsp = {
        typos = {
          initialization_options = {
            diagnosticSeverity = "Warning";
            logLevel = "info";
          };
        };
        rust-analyzer.initialization_options.check.command = "clippy";
        nil.settings.formatting.command = ["nix" "fmt"];
        nixd.settings.formatting.command = ["nix" "fmt"];
      };
      diagnostics.inline.enabled = true;
    };
  };

  home.stateVersion = "25.05";
  home.sessionVariables = {NH_DARWIN_FLAKE = "${inputs.self}";};
  home.packages = with pkgs;
  # Nix developer tools
    [
      # Formatters
      alejandra
      nixfmt-rfc-style
      nixfmt-tree
      # Language servers
      nil
      nixd
      # Helpers
      dix
      snowfallorg.flake
      nh
      omnix
      nixpkgs-hammering
      nixpkgs-reviewFull
      nix-init
      nix-search-tv
      nix-your-shell
      nurl
    ]
    # Version management, GitHub and security
    ++ [
      debase
      delta
      difftastic
      git
      git-backdate
      gitleaks
      gh
      jujutsu
      lazygit
      trufflehog
    ]
    ++ [
      act
      age
      # aider-chat
      angle-grinder
      aria2
      atuin
      bat
      beancount
      binaryen
      bottom
      broot
      browsh
      carapace
      dasel
      devenv
      direnv
      discordo
      # diskonaut # unmaintained
      docker-language-server
      dos2unix
      doxx
      # dt - 1.3.2 broken, waiting for next release (https://github.com/NixOS/nixpkgs/pull/433537)
      dua
      dufs
      dust
      # elixir
      entr
      # erlang
      exercism
      # exiftool
      eza
      fava
      fd
      fennel
      fish
      foundry
      fzf
      gawk
      genact
      # git-lfs
      # git-workspace
      # gleam
      glow
      gnugrep
      gnuplot
      gnused
      gnutar
      gollama
      google-cloud-sdk
      graphviz
      gum
      hck
      helix
      hledger
      httpie
      # hurl
      hyperfine
      id3v2
      ijq
      immich-go
      isync
      just
      jq
      katana
      # kingfisher - not in nixpkgs yet
      kondo
      kubernetes-helm
      lazydocker
      # ledger
      lsd
      lstr
      # lua-language-server
      luarocks
      # lychee
      lynx
      melt
      miniserve
      mmv
      mods
      # mosh
      ncdu
      ncspot
      neonmodem
      neovim
      nethack
      # nodejs
      # nomino
      numbat
      nushell
      ouch
      # parallel
      pay-respects
      pipenv
      pipx
      pqrs
      presenterm
      q
      rclone
      ripgrep
      rsync
      # rust-analyzer
      rye
      sccache
      shellcheck
      shfmt
      slides
      sniffnet
      solc
      spotifyd
      starship
      stylua
      tailspin
      taplo
      tealdeer
      television
      tgpt
      tinymist
      topgrade
      trash-cli
      tree
      trippy
      typescript
      typescript-language-server
      typos
      typst
      unar
      uv
      vhs
      # w3m
      wabt
      # wakeonlan
      watchexec
      websocat
      wget
      wishlist
      xdg-ninja
      xan # maintained fork of xsv
      # xsv
      # yaml-language-server
      yazi
      yq
      yt-dlp
      yubikey-manager
      zellij
      zoxide
      zsh
    ]
    ++ lib.optionals stdenv.isDarwin [mas pinentry_mac zld];
}
