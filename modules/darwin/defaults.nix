{
  system.defaults = {
    dock = {
      orientation = "left";
      tilesize = 36;
    };

    WindowManager = {
      EnableTilingByEdgeDrag = false;
      EnableTiledWindowMargins = false;
      EnableTopTilingByEdgeDrag = false;
      EnableTilingOptionAccelerator = false;
    };

    finder = {
      FXPreferredViewStyle = "Nlsv";
      ShowPathbar = true;
      ShowStatusBar = true;
    };

    NSGlobalDomain = {
      AppleShowAllExtensions = true;
    };

    ".GlobalPreferences" = {
      # -1.0 is no mouse acceleration
      "com.apple.mouse.scaling" = 2.5;
    };
  };
}
