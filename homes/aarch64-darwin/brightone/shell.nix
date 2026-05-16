{ ... }:
{
  # Shells
  programs.zsh.enable = true;
  programs.nushell.enable = true;

  # Prompt
  programs.starship.enable = true;

  # Navigation
  programs.zoxide.enable = true;
  programs.fzf.enable = true;

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

  # Python toolchain manager
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
