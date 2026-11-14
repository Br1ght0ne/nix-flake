{ inputs, ... }: {
  imports = [
    inputs.den.flakeModule
    ./hosts.nix
    ./aspects/ai-agents.nix
    ./aspects/brightone.nix
    ./aspects/editors.nix
    ./aspects/essential-apps.nix
    ./aspects/gaming.nix
    ./aspects/nix-tools.nix
    ./aspects/personal-apps.nix
    ./aspects/personal-dev.nix
    ./aspects/shell.nix
    ./aspects/sync.nix
    ./aspects/system.nix
    ./aspects/terminal.nix
    ./aspects/vcs.nix
    ./aspects/window-management.nix
    ./aspects/work-dev.nix
  ];
}
