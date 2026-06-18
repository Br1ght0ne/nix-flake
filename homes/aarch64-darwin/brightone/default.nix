{
  lib,
  inputs,
  system,
  pkgs,
  ...
}:
{
  imports = [
    ./agents.nix
    ./editors.nix
    ./games.nix
    ./nix.nix
    ./shell.nix
    ./sync.nix
    ./vcs.nix
  ];

  home.stateVersion = "26.05";
  home.packages = (
    with pkgs;
    # Work
    [
      nodejs_22
      pnpm
      rustup
    ]
    ++ [
      act
      age
      # aider-chat
      angle-grinder
      ast-grep
      beancount
      binaryen
      browsh
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
      # fava
      # fish
      # foundry
      libusb1 # for foundryup
      gawk
      genact
      # git-lfs
      # git-workspace
      # gleam
      glow
      gnuplot
      gnused
      gnutar
      gollama
      google-cloud-sdk
      graphviz
      gum
      hck
      hledger
      httpie
      # hurl
      hyperfine
      id3v2
      ijq
      immich-go
      isync
      just
      katana
      # kingfisher - not in nixpkgs yet
      kondo
      kubernetes-helm
      # ledger
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
      # mosh
      ncdu
      neonmodem
      nethack
      # nodejs
      # nomino
      ouch
      # parallel
      pipenv
      pqrs
      presenterm
      q
      rsync
      # rust-analyzer
      rye
      sccache
      shellcheck
      shfmt
      slides
      sniffnet
      solc
      stylua
      tailspin
      taplo
      # tealdeer
      tgpt
      tinymist
      trash-cli
      tree
      typescript
      typescript-language-server
      typos
      typst
      unar
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
      worktrunk
      # yaml-language-server
      # TODO: re-enable once ffmpeg builds on aarch64-darwin (malformed 64-bit version linker error)
      # yazi
      yq
      yubikey-manager
    ]
    ++ lib.optionals stdenv.isDarwin [
      mas
      pinentry_mac
      zld
    ]
    ++ [ inputs.concord.packages.${system}.concord ]
  );
}
