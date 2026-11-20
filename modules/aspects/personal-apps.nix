{
  den.aspects.personal-apps.homeManager = { pkgs, ... }: {
    programs.discord.enable = true;
    programs.obsidian.enable = true;
    programs.thunderbird = {
      enable = true;
      package = pkgs.thunderbird-bin;
    };
    home.packages = with pkgs; [
      alt-tab-macos
      codexbar
      imhex
      losslesscut-bin
      lunar
      shortcat
      tailscale-gui
      trex
      whatsapp-for-mac
      keymapp

      # Fonts are installed by Home Manager's native Darwin font activation.
      cozette
      dejavu_fonts
      nerd-fonts.hack
      nerd-fonts.lilex
      monocraft
    ];
  };
  den.aspects.personal-apps.darwin = {
    homebrew = {
      casks = [
        "anki"
        "calibre"
        "flux-app"
        "ilspy"
        "latest"
        "neat"
        "ollama-app"
        "postgres-app"
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
        "LanguageTool" = 1534275760;
        "Negative" = 1378123825;
        "Orb" = 6477840170;
        "Plash" = 1494023538;
        "Raycast Companion" = 6738274497;
        "The Unarchiver" = 425424353;
        "Velja" = 1607635845;
      };
    };
  };
}
