{ inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    settings = {
      accessibility.ui_scale = 1.2;

      bar.default = {
        end = [
          "notifications"
          "clipboard"
          "temp"
          "cpu"
          "ram"
          "bluetooth"
          "volume"
          "network"
          "battery"
          "session"
        ];
        font_family = "IoskeleyMono Nerd Font Mono";
        font_weight = 400;
        margin_ends = 0;
        radius = 0;
      };

      lockscreen_widgets = {
        enabled = false;
        schema_version = 2;
        widget_order = [
          "lockscreen-login-box@eDP-1"
          "lockscreen-login-box@HDMI-A-2"
        ];
        grid = {
          cell_size = 16;
          major_interval = 4;
          visible = true;
        };
        widget = {
          "lockscreen-login-box@HDMI-A-2" = {
            box_height = 196.0;
            box_width = 810.0;
            cx = 960.0;
            cy = 898.0;
            output = "HDMI-A-2";
            placement_height = 1080.0;
            placement_width = 1920.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_password_reveal = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };
          "lockscreen-login-box@eDP-1" = {
            box_height = 196.0;
            box_width = 810.0;
            cx = 960.0;
            cy = 898.0;
            output = "eDP-1";
            placement_height = 1080.0;
            placement_width = 1920.0;
            rotation = 0.0;
            type = "login_box";
            settings = {
              background_color = "surface_variant";
              background_opacity = 0.88;
              background_radius = 12.0;
              center_password_text = false;
              input_opacity = 1.0;
              input_radius = 6.0;
              layout = "regular";
              show_caps_lock = true;
              show_keyboard_layout = true;
              show_login_button = true;
              show_media = true;
              show_password_reveal = true;
              show_session_buttons = true;
              show_unlock_hint = true;
              show_weather = true;
            };
          };
        };
      };

      shell = {
        font_family = "IoskeleyMono Nerd Font Mono";
        launcher.search_position = "top";
      };

      theme = {
        builtin = "Catppuccin";
        source = "wallpaper";
      };

      wallpaper = {
        enabled = true;
        fill_mode = "crop";
        directory = "${./wallpapers}";
        per_monitor_directories = true;
        default.path = "${./wallpapers/new-zealand-01.jpg}";
        monitor = {
          "HDMI-A-2".directory = "${./wallpapers}";
          "eDP-1".directory = "${./wallpapers}";
        };
        monitors = {
          "HDMI-A-2".path = "${./wallpapers/tokyo-01.jpg}";
          "eDP-1".path = "${./wallpapers/new-zealand-01.jpg}";
        };
      };

      widget.clock = {
        format = "{:%H:%M:%S}";
        tooltip_format = "{:%A} {:%Y-%m-%d} ";
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
