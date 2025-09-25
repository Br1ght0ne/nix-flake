{
  lib,
  pkgs,
  inputs,
  ...
}: {
  programs.nix-index-database.comma.enable = true;

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
