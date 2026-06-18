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

        window_virtual_north = "cmd + shift - k";
        window_virtual_south = "cmd + shift - j";
        window_virtualmove_north = "cmd + alt - k";
        window_virtualmove_south = "cmd + alt - j";
        window_virtualnum_1 = "cmd + alt - 1";
        window_virtualnum_2 = "cmd + alt - 2";
        window_virtualnum_3 = "cmd + alt - 3";
        window_virtualmovenum_1 = "cmd + alt + ctrl - 1";
        window_virtualmovenum_2 = "cmd + alt + ctrl - 2";
        window_virtualmovenum_3 = "cmd + alt + ctrl - 3";
        window_virtualsendnum_1 = "cmd + alt + shift - 1";
        window_virtualsendnum_2 = "cmd + alt + shift - 2";
        window_virtualsendnum_3 = "cmd + alt + shift - 3";

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
      windows = {
        peek-pop = {
          title = "\[Peek Pop\].*";
          floating = true;
        };
      };
    };
  };
}
