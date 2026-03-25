{
  pkgs,
  lib,
  system,
  inputs,
  ...
}: {
  programs.zed-editor = {
    # TODO: something needs ffmpeg which is not built, like for yazi and vhs
    enable = false;
    package = inputs.nixpkgs-stable.legacyPackages.${system}.zed-editor;
    extraPackages = with pkgs; [bash-language-server nil nixd];
    userSettings = {
      edit_predictions = {
        mode = "eager";
        copilot = lib.genAttrs ["proxy" "proxy_no_verify" "enterprise_uri"] (_: null);
        enabled_in_text_threads = false;
      };
      ssh_connections = [
        {
          host = "bazzite";
          username = "brightone";
          projects = [
            {
              paths = ["/home/brightone/code/syndicate-appchains"];
            }
          ];
        }
      ];
      # helix_mode = true;
      vim_mode = true;
      ui_font_size = 14;
      buffer_font_size = 13;
      buffer_font_family = "MonaspiceNe Nerd Font";
      buffer_font_features = lib.genAttrs ["calt" "ss01" "ss02" "liga"] (_: true);
      theme = "Zedokai Darker (Filter Spectrum)";
      terminal = {
        font_size = 12;
        line_height = "standard";
        option_as_meta = true;
        env.EDITOR = "zed --wait";
        shell.program = "nu";
      };
      agent = {
        default_profile = "ask";
        default_model = {
          provider = "copilot_chat";
          model = "claude-3.7-sonnet";
        };
      };
      features.edit_prediction_provider = "zed";
      use_smartcase_search = true;
      inlay_hints.enabled = true;
      languages.Nix.language_servers = ["nixd" "nil"];
      lsp.typos.initialization_options = {
        diagnosticSeverity = "Warning";
        logLevel = "info";
      };
      lsp.rust-analyzer.initialization_options.check.command = "clippy";
      lsp.nil.settings.formatting.command = ["nix" "fmt"];
      lsp.nixd.settings.formatting.command = ["nix" "fmt"];
      diagnostics.inline.enabled = true;
    };
  };
}
