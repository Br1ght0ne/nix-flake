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
        [
          pnpm
          act
          age
          angle-grinder
          ast-grep
          beancount
          binaryen
          browsh
          dasel
          devenv
          # direnv  # substituteStream() in derivation direnv-2.37.1: ERROR: pattern -linkmode=external doesn't match anything in file 'GNUmakefile'
          discordo
          docker-language-server
          dos2unix
          doxx
          # dt - 1.3.2 broken, waiting for next release (https://github.com/NixOS/nixpkgs/pull/433537)
          dua
          dufs
          dust
          entr
          exercism
          libusb1 # for foundryup
          gawk
          genact
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
          hyperfine
          id3v2
          ijq
          immich-go
          isync
          katana
          kondo
          kubernetes-helm
          lstr
          luaPackages.fennel
          luarocks
          lynx
          melt
          miniserve
          mmv
          ncdu
          neonmodem
          ouch
          pipenv
          pqrs
          presenterm
          q
          rsync
          sccache
          shellcheck
          shfmt
          slides
          sniffnet
          solc
          stylua
          tailspin
          taplo
          tgpt
          tinymist
          trash-cli
          tree
          typescript
          typescript-language-server
          typos
          typst
          unar
          # vhs and yazi need an ffmpeg build that works on aarch64-darwin.
          wabt
          watchexec
          websocat
          wget
          wishlist
          xdg-ninja
          xan # maintained fork of xsv
          worktrunk
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
