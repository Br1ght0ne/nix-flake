{ inputs, ... }: {
  den.aspects.personal-dev.homeManager =
    {
      lib,
      pkgs,
      ...
    }:
    {
      home.packages = (
        with pkgs;
        # Work
        [
          pnpm
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
        ++ lib.optionals stdenv.hostPlatform.isDarwin [
          mas
          pinentry_mac
          zld
        ]
        ++ [ inputs.concord.packages.${pkgs.stdenv.hostPlatform.system}.concord ]
      );
    };
}
