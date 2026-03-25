{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      cleanup = "check";
      upgrade = false;
    };
    # global.autoUpdate = true;
    taps = [
      "anomalyco/tap"
      "br1ght0ne/cdda"
    ];
    brews = [
      "ansible"
      "opencode"
      "paneru"
    ];
    caskArgs.require_sha = true;
    casks = [
      "1password"
      "1password-cli"
      "alt-tab"
      "android-studio"
      "anki"
      "audacity"
      "balenaetcher"
      "beekeeper-studio"
      "betterdisplay"
      "bettertouchtool"
      "blackhole-16ch"
      "bruno"
      "calibre"
      "cataclysm"
      "cataclysm-rc"
      "cataclysm-bn-nightly"
      "cataclysm-tlg"
      "claude"
      "db-browser-for-sqlite"
      "deepl"
      "dosbox"
      "dotnet-sdk"
      "dungeon-crawl-stone-soup-tiles"
      "element"
      "emacs-app"
      "flox"
      "flux-app"
      "font-cozette"
      "font-dejavu"
      "font-hack-nerd-font"
      "font-lilex-nerd-font"
      "font-monaspace"
      "font-monaspice-nerd-font"
      "font-monocraft"
      "ghostty"
      "gimp"
      "google-chrome"
      "heroic"
      "ilspy"
      "imhex"
      "inkscape"
      "latest"
      "ledger-wallet"
      "losslesscut"
      "lunar"
      "maccy"
      "macfuse"
      "miniconda"
      "mitmproxy"
      "mono-mdk"
      "moonlight"
      "mounty"
      "musicbrainz-picard"
      "neat"
      "obsidian"
      "ollama-app"
      "orbstack"
      "orion"
      "parsec"
      "postgres-app"
      "postico"
      "powershell"
      "protonvpn"
      "raycast"
      "rider"
      "shattered-pixel-dungeon"
      "shortcat"
      "signal"
      "tailscale-app"
      "telegram"
      "thunderbird"
      "tor-browser"
      "trex"
      "trezor-suite"
      "ultimaker-cura"
      "warp"
      "wezterm"
      "whatsapp"
      "xonotic"
      "yaak"
      "zed"
      "zen"
    ];
    masApps = {
      "Actions" = 1586435171;
      "Bitwarden" = 1352778147;
      "Camera Preview" = 1632827132;
      "Developer" = 640199958;
      "DigiDoc4" = 1370791134;
      "Enchanted" = 6474268307;
      "Fantastical" = 975937182;
      "Gemini 2" = 1090488118;
      "Keymapp" = 6472865291;
      "Keynote" = 409183694;
      "Negative" = 1378123825;
      "Numbers" = 409203825;
      "Pages" = 409201541;
      "Plash" = 1494023538;
      "Raycast Companion" = 6738274497;
      "The Unarchiver" = 425424353;
      "Velja" = 1607635845;
      "WhatsApp" = 310633997;
      "Xcode" = 497799835;
    };
  };
}
