{ inputs, ... }: {
  den.aspects.shell.homeManager =
    {
      config,
      lib,
      pkgs,
      ...
    }:
    {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];
      # Local installers put optional application launchers here. Append them so
      # they cannot override Nix-managed tools; HM loads this for zsh and Nushell.
      home.sessionVariablesExtra = ''
        for local_bin in "$HOME/.lmstudio/bin" "$HOME/.local/bin"; do
          if [ -d "$local_bin" ]; then
            case ":$PATH:" in
              *":$local_bin:"*) ;;
              *) export PATH="$PATH:$local_bin" ;;
            esac
          fi
        done
        unset local_bin
      '';
      programs = {
        zsh.enable = true;
        nushell = {
          enable = true;
          # Load the generated Darwin and Home Manager environment once.
          loadSessionVariables = true;
          settings = {
            buffer_editor = "zeditor";
            show_banner = false;
          };
        };

        starship.enable = true;
        zoxide.enable = true;
        fzf = {
          enable = true;
          # Atuin already owns Ctrl-R.
          historyWidget.command = "";
        };
        atuin.enable = true;
        carapace.enable = true;
        pay-respects.enable = true;
        television.enable = true;
        zellij.enable = true;

        # Ghostty launches the same Nushell package configured above.
        ghostty = {
          enable = true;
          package = pkgs.ghostty-bin;
          settings = {
            font-family = "Monaspace Neon";
            font-size = 11;
            theme = "gogh-oxocarbon";
            command = lib.getExe config.programs.nushell.package;
          };
          themes = {
            gogh-oxocarbon = {
              palette = [
                "0=#262626"
                "1=#EE5396"
                "2=#42BE65"
                "3=#FFE97B"
                "4=#33B1FF"
                "5=#FF7EB6"
                "6=#3DDBD9"
                "7=#DDE1E6"
                "8=#393939"
                "9=#EE5396"
                "10=#42BE65"
                "11=#FFE97B"
                "12=#33B1FF"
                "13=#FF7EB6"
                "14=#3DDBD9"
                "15=#FFFFFF"
              ];
              background = "161616";
              foreground = "ffffff";
              cursor-color = "6f6f6f";
            };
          };
        };

        # Command-line utilities
        aria2.enable = true;
        bat.enable = true;
        bottom.enable = true;
        broot.enable = true;
        eza.enable = true;
        fd.enable = true;
        gpg.enable = true;
        grep.enable = true;
        jq.enable = true;
        lazydocker.enable = true;
        lsd.enable = true;
        mods.enable = true;
        ncspot.enable = true;
        numbat.enable = true;
        ripgrep.enable = true;
        topgrade.enable = true;
        trippy.enable = true;
        yt-dlp.enable = true;

        # Toolchains and Nix
        mise = {
          enable = true;
          # Global tools come from Nix. Projects may still select tools in mise.toml.
          globalConfig.tools = { };
        };
        uv.enable = true;
        nh = {
          enable = true;
          # Use the live checkout, not the immutable flake copy in /nix/store.
          flake = "${config.home.homeDirectory}/dev/github.com/Br1ght0ne/nix-flake";
        };
        nix-index-database.comma.enable = true;
        nix-init.enable = true;
        nix-search-tv.enable = true;
        nix-your-shell.enable = true;
      };

      home.packages = with pkgs; [
        monaspace
        # Formatters
        alejandra
        nixfmt
        nixfmt-tree
        # Language servers
        nil
        nixd
        nixpkgs-hammering
        nixpkgs-reviewFull
        nurl
      ];
    };
}
