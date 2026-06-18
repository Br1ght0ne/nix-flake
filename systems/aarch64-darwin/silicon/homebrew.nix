{
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = false;
      upgrade = false;
    };
    # global.autoUpdate = true;
    brews = [ ];
    caskArgs.require_sha = true;
    casks = [
      "alt-tab"
      "anki"
      "calibre"
      "codexbar"
      "discord"
      "emacs-app"
      "flux-app"
      "font-cozette"
      "font-dejavu"
      "font-hack-nerd-font"
      "font-lilex-nerd-font"
      "font-monaspace"
      "font-monaspice-nerd-font"
      "font-monocraft"
      "google-chrome"
      "heroic"
      "ilspy"
      "imhex"
      "latest"
      "losslesscut"
      "lunar"
      "moonlight"
      "neat"
      "obsidian"
      "ollama-app"
      "parsec"
      "postgres-app"
      "protonvpn"
      "raycast"
      "shattered-pixel-dungeon"
      "shortcat"
      "tailscale-app"
      "telegram"
      "thaw"
      "thunderbird"
      "trex"
      "whatsapp"
      "zed"
      "zen"
    ];
    masApps = {
      "Actions" = 1586435171;
      "Bitwarden" = 1352778147;
      "Camera Preview" = 1632827132;
      "Dato" = 1470584107;
      "Developer" = 640199958;
      "DigiDoc4" = 1370791134;
      "Fantastical" = 975937182;
      "Gemini 2" = 1090488118;
      "Keymapp" = 6472865291;
      "LanguageTool" = 1534275760;
      "Negative" = 1378123825;
      "Orb" = 6477840170;
      "Plash" = 1494023538;
      "Raycast Companion" = 6738274497;
      "The Unarchiver" = 425424353;
      "Velja" = 1607635845;
      "WhatsApp" = 310633997;
    };
  };
}
