{
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "None";
        opacity = 1.0;
        blur = false;
        dynamic_padding = true;
        padding = {
          x = 5;
          y = 5;
        };
      };

      font = {
        size = 12;
        normal = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Regular";
        };
        bold = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold";
        };
        italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Italic";
        };
        bold_italic = {
          family = "JetBrainsMono Nerd Font Mono";
          style = "Bold Italic";
        };
      };

      # Tokyo Passion
      colors = {
        primary = {
          background = "#1a1b26";
          foreground = "#c0caf5";
        };
        cursor = {
          cursor = "#c0caf5";
          text = "#15161e";
        };
        selection = {
          background = "#33467c";
          text = "#c0caf5";
        };
        normal = {
          black = "#15161e";
          red = "#f7768e";
          green = "#1DBA9A";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#32ADE6";
          white = "#a9b1d6";
        };
        bright = {
          black = "#414868";
          red = "#f7768e";
          green = "#3CC4A9";
          yellow = "#e0af68";
          blue = "#7aa2f7";
          magenta = "#bb9af7";
          cyan = "#478CC7";
          white = "#c0caf5";
        };
      };
    };
  };
}
