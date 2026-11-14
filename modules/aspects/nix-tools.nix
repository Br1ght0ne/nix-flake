{ inputs, ... }: {
  den.aspects.nix-tools.homeManager =
    { pkgs, config, ... }:
    {
      imports = [ inputs.nix-index-database.homeModules.nix-index ];
      programs.nh = {
        enable = true;
        # Use the live checkout, not the immutable flake copy in /nix/store.
        flake = "${config.home.homeDirectory}/dev/github.com/Br1ght0ne/nix-flake";
      };
      programs.nix-index-database.comma.enable = true;
      programs.nix-init.enable = true;
      programs.nix-search-tv.enable = true;
      programs.nix-your-shell.enable = true;

      home.packages = with pkgs; [
        # Formatters
        alejandra
        nixfmt
        nixfmt-tree
        # Language servers
        nil
        nixd
        # snowfallorg.flake
        nixpkgs-hammering
        nixpkgs-reviewFull
        nurl
      ];
    };
}
