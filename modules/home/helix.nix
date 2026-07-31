{
  programs.helix = {
    enable = true;
    defaultEditor = true;

    settings = {
      theme = "tokyonight";

      editor = {
        line-number = "relative";
        mouse = true;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker = {
          hidden = false;
        };

        soft-wrap = {
          enable = true;
        };
      };
    };
  };
}
