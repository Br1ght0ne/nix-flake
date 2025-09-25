{...}: {
  imports = [./aerospace.nix ./homebrew.nix ./system.nix];
  # Don't manage Determinate Nix
  nix.enable = false;
}
