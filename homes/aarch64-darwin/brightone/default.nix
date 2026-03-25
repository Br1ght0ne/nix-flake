{
  lib,
  inputs,
  system,
  pkgs,
  ...
}:
let
  pkgs-stable = inputs.nixpkgs-stable.legacyPackages.${system};
in
{
  imports = [ ./zed.nix ];

  programs.nix-index-database.comma.enable = true;

  home.stateVersion = "25.11";
  home.packages =
    (
      with pkgs;
      # Nix developer tools
      [
        # Formatters
        alejandra
        nixfmt
        nixfmt-tree
        # Language servers
        nil
        nixd
        # Helpers
        dix
        # snowfallorg.flake
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
        jjui
        lazyjj
        lazygit
        trufflehog
      ]
      ++ [
        act
        age
        # aider-chat
        angle-grinder
        aria2
        ast-grep
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
        # direnv  # substituteStream() in derivation direnv-2.37.1: ERROR: pattern -linkmode=external doesn't match anything in file 'GNUmakefile'
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
        # fava
        fd
        # fish
        # foundry
        libusb1 # for foundryup
        fzf
        gawk
        genact
        # git-lfs
        # git-workspace
        # gleam
        glow
        gnugrep
        gnupg
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
        luaPackages.fennel
        luarocks
        # lychee
        lynx
        melt
        miniserve
        # mise
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
        # tealdeer
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
        # TODO: re-enable once ffmpeg builds on aarch64-darwin (malformed 64-bit version linker error)
        # vhs
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
        # TODO: re-enable once ffmpeg builds on aarch64-darwin (malformed 64-bit version linker error)
        # yazi
        yq
        yt-dlp
        yubikey-manager
        zellij
        zoxide
        zsh
      ]
      ++ lib.optionals stdenv.isDarwin [
        mas
        pinentry_mac
        zld
      ]
    )
    ++ lib.optionals pkgs.stdenv.isDarwin (with pkgs.brightone; [ ice-bar ]);
}
