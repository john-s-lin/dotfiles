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

  # Disable legacy Nix channels (pure flakes setup)
  nix.channel.enable = false;

  # Silence Lix/Nix parser deprecation warnings for legacy library identifiers
  nix.settings.extra-deprecated-features = [ "or-as-identifier" ];
}
