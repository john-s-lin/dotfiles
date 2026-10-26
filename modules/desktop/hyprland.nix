{
  programs.hyprland.enable = true;

  # Noctalia's lock screen authenticates against the standard login PAM stack,
  # which programs.shadow already provides by default.
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;
}
