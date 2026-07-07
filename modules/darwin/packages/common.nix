{
  homebrew = {
    enable = true;
    casks = [
      "ghostty"
      "rectangle"
    ];
    # Always upgrade casks
    greedyCasks = true;
    global.autoUpdate = false;
    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };
  };
}
