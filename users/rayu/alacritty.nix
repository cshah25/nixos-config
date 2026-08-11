{ config, pkgs, ... }:

{
  programs.alacritty = {
    enable = true;
    settings = {
      general = {
        live_config_reload = true;
        working_directory = "None";
      };

      env = {
        TERM = "xterm-256color";
        WINIT_X11_SCALE_FACTOR = "1";
      };

      window = {
        dynamic_padding = true;
        decorations = "full";
        opacity = 1;
        decorations_theme_variant = "Dark";
        dimensions = {
          columns = 100;
          lines = 30;
        };
        class = {
          instance = "Alacritty";
          general = "Alacritty";
        };
      };

      scrolling = {
        history = 10000;
        multiplier = 3;
      };

      font = {
        size = 12;
        normal = { family = "MesloLGS Nerd Font"; style = "Regular"; };
        bold = { family = "MesloLGS Nerd Font"; style = "Bold"; };
        italic = { family = "MesloLGS Nerd Font"; style = "Italic"; };
        bold_italic = { family = "MesloLGS Nerd Font"; style = "Bold Italic"; };
      };

      colors = {
        draw_bold_text_with_bright_colors = true;
        primary = {
          background = "#1e1e2e";
          foreground = "#cdd6f4";
          dim_foreground = "#7f849c";
          bright_foreground = "#cdd6f4";
        };
        cursor = {
          text = "#1e1e2e";
          cursor = "#f5e0dc";
        };
        vi_mode_cursor = {
          text = "#1e1e2e";
          cursor = "#b4befe";
        };
        search = {
          matches = { foreground = "#1e1e2e"; background = "#a6adc8"; };
          focused_match = { foreground = "#1e1e2e"; background = "#a6e3a1"; };
        };
        footer_bar = { foreground = "#1e1e2e"; background = "#a6adc8"; };
        hints = {
          start = { foreground = "#1e1e2e"; background = "#f9e2af"; };
          end = { foreground = "#1e1e2e"; background = "#a6adc8"; };
        };
        selection = { text = "#1e1e2e"; background = "#f5e0dc"; };
        normal = {
          black = "#45475a";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#bac2de";
        };
        bright = {
          black = "#585b70";
          red = "#f38ba8";
          green = "#a6e3a1";
          yellow = "#f9e2af";
          blue = "#89b4fa";
          magenta = "#f5c2e7";
          cyan = "#94e2d5";
          white = "#a6adc8";
        };
        indexed_colors = [
          { index = 16; color = "#fab387"; }
          { index = 17; color = "#f5e0dc"; }
        ];
      };

      selection = {
        semantic_escape_chars = ",│`|:\"' ()[]{}<>\t";
        save_to_clipboard = true;
      };

      cursor = {
        style = "Underline";
        vi_mode_style = "None";
        unfocused_hollow = true;
        thickness = 0.15;
      };

      mouse = {
        hide_when_typing = true;
        bindings = [
          { mouse = "Middle"; action = "PasteSelection"; }
        ];
      };

      keyboard = {
        bindings = [
          { key = "Paste"; action = "Paste"; }
          { key = "Copy"; action = "Copy"; }
          { key = "L"; mods = "Control"; action = "ClearLogNotice"; }
          { key = "L"; mods = "Control"; mode = "~Vi"; chars = "\\f"; }
          { key = "PageUp"; mods = "Shift"; mode = "~Alt"; action = "ScrollPageUp"; }
          { key = "PageDown"; mods = "Shift"; mode = "~Alt"; action = "ScrollPageDown"; }
          { key = "Home"; mods = "Shift"; mode = "~Alt"; action = "ScrollToTop"; }
          { key = "End"; mods = "Shift"; mode = "~Alt"; action = "ScrollToBottom"; }
          { key = "V"; mods = "Control|Shift"; action = "Paste"; }
          { key = "C"; mods = "Control|Shift"; action = "Copy"; }
          { key = "F"; mods = "Control|Shift"; action = "SearchForward"; }
          { key = "B"; mods = "Control|Shift"; action = "SearchBackward"; }
          { key = "C"; mods = "Control|Shift"; mode = "Vi"; action = "ClearSelection"; }
          { key = "Key0"; mods = "Control"; action = "ResetFontSize"; }
        ];
      };
    };
  };
}
