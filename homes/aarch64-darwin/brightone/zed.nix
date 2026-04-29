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
      cli_default_open_behavior = "new_window";
      project_panel.dock = "right";
      outline_panel.dock = "right";
      collaboration_panel.dock = "right";
      git_panel.dock = "right";
      diff_view_style = "unified";
      focus_follows_mouse.enabled = false;
      agent_servers = {
        "pi-acp".type = "registry";
        "claude-acp".type = "registry";
      };
      context_servers = {
        "mcp-server-github" = {
          enabled = false;
          settings = {};
        };
        kagimcp = {
          enabled = false;
          settings = {
            kagi_api_key = "qa-JoxtgPScDSQMMkWos9cZpXY9KY29ttjS7fdrvq_o.p0IJtrdoOmzf-MBGMoyZxNbSQwCcDDbzpImakJDy5-c";
            kagi_summarizer_engine = "cecil";
            kagi_fastgpt_cache = true;
            kagi_fastgpt_web_search = true;
          };
        };
        "mcp-server-context7" = {
          enabled = true;
          settings.context7_api_key = "ctx7sk-3c15f0e7-b151-49a2-b88a-d459f4ede12b";
        };
      };
      colorize_brackets = true;
      agent = {
        dock = "left";
        tool_permissions.default = "allow";
        inline_assistant_model = {
          provider = "copilot_chat";
          model = "claude-sonnet-4.6";
        };
        favorite_models = [
          {
            provider = "copilot_chat";
            model = "claude-opus-4.5";
            enable_thinking = false;
          }
          {
            provider = "copilot_chat";
            model = "claude-opus-4.6";
            enable_thinking = false;
          }
          {
            provider = "copilot_chat";
            model = "claude-sonnet-4.6";
            enable_thinking = true;
            effort = "high";
          }
          {
            provider = "copilot_chat";
            model = "claude-sonnet-4.5";
            enable_thinking = false;
          }
          {
            provider = "copilot_chat";
            model = "gpt-5.3-codex";
            enable_thinking = false;
          }
        ];
        default_model = {
          effort = "high";
          enable_thinking = true;
          model = "claude-sonnet-4.6";
          provider = "copilot_chat";
        };
        default_profile = "write";
      };
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
      edit_predictions = {
        provider = "copilot";
        mode = "eager";
        copilot = lib.genAttrs ["proxy" "proxy_no_verify" "enterprise_uri"] (_: null);
        enabled_in_text_threads = false;
      };
      use_smartcase_search = true;
      inlay_hints.enabled = true;
      languages = {
        Nix.language_servers = ["nixd" "nil"];
        Solidity.tab_size = 2;
      };
      diagnostics.inline.enabled = true;
      lsp = {
        typos.initialization_options = {
          diagnosticSeverity = "Warning";
          logLevel = "info";
        };
        "rust-analyzer" = {
          binary = {
            path = "/Users/brightone/.local/share/cargo/bin/rust-analyzer";
            arguments = [];
          };
          initialization_options.check.command = "clippy";
        };
        nil.settings.formatting.command = ["nix" "fmt"];
        nixd.settings.formatting.command = ["nix" "fmt"];
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
    };
  };
}
