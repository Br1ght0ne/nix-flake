{
  services.aerospace = {
    enable = true;
    settings = {
      enable-normalization-opposite-orientation-for-nested-containers = true;
      accordion-padding = 30;
      default-root-container-orientation = "auto";
      gaps = {
        inner = {
          horizontal = 0;
          vertical = 0;
        };
        outer = {
          left = 0;
          bottom = 0;
          top = 0;
          right = 0;
        };
      };
      mode.main.binding = {
        # Workspace number keys
        alt-1 = "workspace 1";
        alt-2 = "workspace 2";
        alt-3 = "workspace 3";
        alt-4 = "workspace 4";
        alt-5 = "workspace 5";
        alt-6 = "workspace 6";
        alt-7 = "workspace 7";
        alt-8 = "workspace 8";
        alt-9 = "workspace 9";

        # Move to workspace number keys
        alt-shift-1 = "move-node-to-workspace 1";
        alt-shift-2 = "move-node-to-workspace 2";
        alt-shift-3 = "move-node-to-workspace 3";
        alt-shift-4 = "move-node-to-workspace 4";
        alt-shift-5 = "move-node-to-workspace 5";
        alt-shift-6 = "move-node-to-workspace 6";
        alt-shift-7 = "move-node-to-workspace 7";
        alt-shift-8 = "move-node-to-workspace 8";
        alt-shift-9 = "move-node-to-workspace 9";

        # Non-numeric keybindings
        alt-comma = "layout accordion horizontal vertical";
        alt-enter = "exec-and-forget open -n /Applications/Ghostty.app";
        alt-h = "focus left";
        alt-j = "focus down";
        alt-k = "focus up";
        alt-l = "focus right";
        alt-shift-f = "move-mouse window-force-center";
        alt-shift-h = "move left";
        alt-shift-j = "move down";
        alt-shift-k = "move up";
        alt-shift-l = "move right";
        alt-shift-m = "mode monitors";
        alt-shift-minus = "resize smart -50";
        alt-shift-equal = "resize smart +50";
        alt-shift-semicolon = "mode service";
        alt-shift-tab = "workspace --wrap-around prev";
        alt-slash = "layout tiles horizontal vertical";
        alt-tab = "workspace --wrap-around next";
      };
      mode.monitors.binding = {
        # Number keys
        "1" = [
          "focus-monitor 1"
          "mode main"
        ];
        "2" = [
          "focus-monitor 2"
          "mode main"
        ];
        "3" = [
          "focus-monitor 3"
          "mode main"
        ];
        "4" = [
          "focus-monitor 4"
          "mode main"
        ];
        "5" = [
          "focus-monitor 5"
          "mode main"
        ];
        "6" = [
          "focus-monitor 6"
          "mode main"
        ];
        "7" = [
          "focus-monitor 7"
          "mode main"
        ];
        "8" = [
          "focus-monitor 8"
          "mode main"
        ];
        "9" = [
          "focus-monitor 9"
          "mode main"
        ];

        # Shift + number keys
        shift-1 = [
          "move-workspace-to-monitor 1"
          "mode main"
        ];
        shift-2 = [
          "move-workspace-to-monitor 2"
          "mode main"
        ];
        shift-3 = [
          "move-workspace-to-monitor 3"
          "mode main"
        ];
        shift-4 = [
          "move-workspace-to-monitor 4"
          "mode main"
        ];
        shift-5 = [
          "move-workspace-to-monitor 5"
          "mode main"
        ];
        shift-6 = [
          "move-workspace-to-monitor 6"
          "mode main"
        ];
        shift-7 = [
          "move-workspace-to-monitor 7"
          "mode main"
        ];
        shift-8 = [
          "move-workspace-to-monitor 8"
          "mode main"
        ];
        shift-9 = [
          "move-workspace-to-monitor 9"
          "mode main"
        ];

        # Non-numeric keys
        esc = [
          "mode main"
        ];
        tab = [
          "focus-monitor --wrap-around next"
          "mode main"
        ];
        shift-tab = [
          "move-workspace-to-monitor --wrap-around next"
          "mode main"
        ];
      };
      mode.service.binding = {
        # All non-numeric keys
        alt-shift-h = [
          "join-with left"
          "mode main"
        ];
        alt-shift-j = [
          "join-with down"
          "mode main"
        ];
        alt-shift-k = [
          "join-with up"
          "mode main"
        ];
        alt-shift-l = [
          "join-with right"
          "mode main"
        ];
        backspace = [
          "close-all-windows-but-current"
          "mode main"
        ];
        esc = [
          "reload-config"
          "mode main"
        ];
        f = [
          "layout floating tiling"
          "mode main"
        ];
        r = [
          "flatten-workspace-tree"
          "mode main"
        ];
      };
      enable-normalization-flatten-containers = true;
      default-root-container-layout = "tiles";
      key-mapping.preset = "qwerty";
      exec.inherit-env-vars = true;
    };
  };
}
