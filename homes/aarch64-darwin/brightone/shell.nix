{ pkgs, ... }: {
  # Terminals
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty-bin;
    settings = {
      font-family = "Monaspace Neon";
      font-size = 11;
      theme = "gogh-oxocarbon";
      command = "${pkgs.nushell}/bin/nu";
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

  # Shells
  programs.zsh.enable = true;
  programs.nushell = {
    enable = true;
    settings = {
      buffer_editor = "zed";
      show_banner = false;
    };
    extraConfig = ''
      # Nix shell integration — mirrors nix-daemon.sh.
      # __ETC_PROFILE_NIX_SOURCED also prevents /etc/profile.d/nix-daemon.sh from
      # re-running if a POSIX shell is spawned from this session.
      if not ("__ETC_PROFILE_NIX_SOURCED" in $env) {
          $env.__ETC_PROFILE_NIX_SOURCED = 1

          let nix_profile = ($env.HOME | path join ".nix-profile")
          let nix_default = "/nix/var/nix/profiles/default"

          # Used by nix(1) for profile management
          $env.NIX_PROFILES = $"($nix_default) ($nix_profile)"

          # TLS verification for nix fetches and nix-built tools (curl, git, …)
          if not ("NIX_SSL_CERT_FILE" in $env) {
              let cert = [
                  "/etc/ssl/certs/ca-certificates.crt"          # macOS (Nix-provided), NixOS, Ubuntu, Arch
                  "/etc/ssl/ca-bundle.pem"                       # openSUSE
                  "/etc/ssl/certs/ca-bundle.crt"                 # Old NixOS
                  "/etc/pki/tls/certs/ca-bundle.crt"             # Fedora, CentOS
                  $"($nix_profile)/etc/ssl/certs/ca-bundle.crt"  # fallback: cacert in profile
                  $"($nix_default)/etc/ssl/certs/ca-bundle.crt"  # fallback: cacert in default
              ] | where { |p| $p | path exists } | first

              if $cert != null { $env.NIX_SSL_CERT_FILE = $cert }
          }

          # Per-user profile first, then system-wide default — matches nix-daemon.sh order
          $env.PATH = (
              $env.PATH
              | prepend $"($nix_default)/bin"
              | prepend $"($nix_profile)/bin"
              | uniq
          )
      }

      # Language-toolchain / user-installed bins.
      # Each entry is guarded by path exists so this stays portable.
      $env.PATH = (
          $env.PATH
          | prepend ([ "/run/current-system/sw/bin" ] | where { |p| $p | path exists })
          | prepend ([ ($env.HOME | path join ".local" "share" "cargo" "bin") ] | where { |p| $p | path exists })
          | prepend ([ ($env.HOME | path join ".foundry" "bin") ] | where { |p| $p | path exists })
          | prepend ([ ($env.HOME | path join ".bun" "install" "global" "~" ".bun" "bin") ] | where { |p| $p | path exists })
          | prepend ([ ($env.HOME | path join ".bun" "bin") ] | where { |p| $p | path exists })
          | prepend ([ ($env.HOME | path join ".config" "emacs" "bin") ] | where { |p| $p | path exists })
          | uniq
      )

      # Homebrew integration — mirrors `brew shellenv` for Nushell.
      # /opt/homebrew = Apple Silicon; /usr/local = Intel.
      let brew_prefix = (
          [ "/opt/homebrew" "/usr/local" ]
          | where { |p| $p | path exists }
          | first
          | default null
      )
      if $brew_prefix != null {
          $env.HOMEBREW_PREFIX     = $brew_prefix
          $env.HOMEBREW_CELLAR     = $"($brew_prefix)/Cellar"
          $env.HOMEBREW_REPOSITORY = $brew_prefix
          $env.PATH = (
              $env.PATH
              | prepend $"($brew_prefix)/sbin"
              | prepend $"($brew_prefix)/bin"
              | uniq
          )
      }

      $env.PATH = $env.PATH | prepend $"($nu.home-dir)/.local/bin" | uniq
    '';
  };

  # Prompt
  programs.starship.enable = true;

  # Navigation
  programs.zoxide.enable = true;
  programs.fzf.enable = true;
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
  programs.mise.enable = true;
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
}
