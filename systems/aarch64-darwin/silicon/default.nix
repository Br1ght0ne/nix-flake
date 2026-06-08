{ ... }: {
  imports = [
    ./homebrew.nix
    ./system.nix
    ./wm.nix
  ];
  # Don't manage Determinate Nix
  nix.enable = false;
}
