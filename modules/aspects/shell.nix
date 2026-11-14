{
  den.aspects.shell.homeManager = { pkgs, ... }: {
    # Shells
    programs.zsh.enable = true;
    # Local installers put LM Studio and Herdr launchers here. Append them so
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
    programs.nushell = {
      # Load the generated Darwin and Home Manager environment once.
      loadSessionVariables = true;
      enable = true;
      settings = {
        buffer_editor = "zed";
        show_banner = false;
      };

    };

    # Prompt
    programs.starship.enable = true;

    # Navigation
    programs.zoxide.enable = true;
    programs.fzf.enable = true;
    # Atuin already owns Ctrl-R; avoid competing fzf bindings.
    programs.fzf.historyWidget.command = "";
    programs.atuin.enable = true;

    # Completion
    programs.carapace.enable = true;

    # Shell corrections
    programs.pay-respects.enable = true;

    # Download manager
    programs.aria2.enable = true;

    # grep (gnugrep)
    programs.grep.enable = true;

    # GPG
    programs.gpg.enable = true;

    # JSON
    programs.jq.enable = true;

    # Docker TUI
    programs.lazydocker.enable = true;

    # AI in the terminal
    programs.mods.enable = true;

    # Calculator with units
    programs.numbat.enable = true;

    # Cloud sync
    programs.rclone.enable = true;

    # Fuzzy finder TUI
    programs.television.enable = true;

    # Toolchain managers
    programs.mise = {
      enable = true;
      # Global tools come from Nix. Projects may still select tools in mise.toml.
      globalConfig.tools = { };
    };
    programs.uv.enable = true;

    # Terminal multiplexer
    programs.zellij.enable = true;

    # Viewers / syntax highlighting
    programs.bat.enable = true;

    # Directory browsers
    programs.broot.enable = true;

    # ls replacements
    programs.eza.enable = true;
    programs.lsd.enable = true;

    # Search
    programs.fd.enable = true;
    programs.ripgrep.enable = true;

    # Process/system monitor
    programs.bottom.enable = true;

    # Upgrade all the things
    programs.topgrade.enable = true;

    # Network diagnostics
    programs.trippy.enable = true;

    # Spotify TUI
    programs.ncspot.enable = true;

    # Video/audio downloader
    programs.yt-dlp.enable = true;
  };
}
