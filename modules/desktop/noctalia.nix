{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    settings = {
      wallpaper = {
        enabled = true;
        fill_mode = "crop";
        default.path = "${./wallpapers/new-zealand-01.jpg}";
      };

      idle = {
        pre_action_fade_seconds = 0;
        behavior_order = [
          "dim"
          "lock"
          "screen-off"
          "suspend"
        ];
        behavior = {
          dim = {
            enabled = true;
            timeout = 120;
            action = "command";
            command = "brightnessctl -s set 5%";
            resume_command = "brightnessctl -r";
          };
          lock = {
            enabled = true;
            timeout = 300;
            action = "lock";
          };
          "screen-off" = {
            enabled = true;
            timeout = 330;
            action = "screen_off";
          };
          suspend = {
            enabled = true;
            timeout = 1800;
            action = "suspend";
            lock_before_suspend = true;
          };
        };
      };
    };
  };
}
