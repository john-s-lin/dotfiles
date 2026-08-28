{
  services.mako = {
    enable = true;
    settings = {
      # Use 10 seconds unless a notification or urgency rule overrides it.
      default-timeout = 10000;
      background-color = "#1e1e2e";
      text-color = "#cdd6f4";
      border-color = "#89b4fa";
      font = "Geist Mono Nerd Font 12";
      anchor = "top-right";
      margin = 10;
      padding = 10;
      border-size = 2;
      border-radius = 10;
      icons = true;
      max-icon-size = 48;
      actions = true;

      "urgency=low".default-timeout = 5000;
      "urgency=normal".default-timeout = 10000;
      "urgency=critical".default-timeout = 0;
    };
  };
}
