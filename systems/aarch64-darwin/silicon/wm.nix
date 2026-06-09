{ inputs, ... }: {
  imports = [ inputs.paneru.darwinModules.paneru ];

  services.paneru = {
    enable = true;
    settings = {
      options = {
        focus_follows_mouse = true;
        mouse_follows_focus = true;
        horizontal_mouse_warp = -1;
      };
      swipe.gesture.vertical = true;
      decorations = {
        workspace_menu_status = true;
        workspace_popup_status = true;
      };
      bindings = {
        window_focus_west = "alt - h";
        window_focus_first = "alt - 6";
        window_focus_east = "alt - l";
        window_focus_last = "alt - 4";
        window_focus_north = "alt - k";
        window_focus_south = "alt - j";

        window_swap_west = "alt + shift - h";
        window_swap_first = "alt + shift - 6";
        window_swap_east = "alt + shift - l";
        window_swap_last = "alt + shift - 4";
        window_swap_north = "alt + shift - k";
        window_swap_south = "alt + shift - j";

        window_nextdisplay = "alt - m";
        window_nextdisplaysend = "alt + shift - m";

        window_resize = "alt - r";
        window_fullwidth = "alt + shift - r";
        window_center = "alt - c";
        window_manage = "alt + shift - f";
        window_stack = "alt - s";
        window_unstack = "alt + shift - s";

        quit = "ctrl + alt - q";
      };
    };
  };
}
