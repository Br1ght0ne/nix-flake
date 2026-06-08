{ pkgs, ... }:
{
  programs.nh = {
    enable = true;
    flake = toString ../../..;
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
}
