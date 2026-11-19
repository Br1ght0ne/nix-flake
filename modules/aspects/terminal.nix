{
  den.aspects.terminal.homeManager = { pkgs, ... }: {
    # Keep the configured font available in integrated and standalone homes.
    home.packages = [ pkgs.monaspace ];

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

  };
}
