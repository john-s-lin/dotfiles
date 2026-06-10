{
  lib,
  pkgs,
  ...
}:
let
  lua = lib.generators.mkLuaInline;
  call = _args: { inherit _args; };
  bind =
    keys: dispatcher:
    call [
      keys
      (lua dispatcher)
    ];
  bindWith =
    keys: dispatcher: options:
    call [
      keys
      (lua dispatcher)
      options
    ];

  terminal = "ghostty";
  fileManager = "cosmic-files";
  menu = "rofi -show drun";
  laptopMonitor = "eDP-1";
  homeMonitor = "DP-2";
  workMonitor = "DP-1";
in
{
  home.packages = with pkgs; [
    rofi
    waybar
    hyprshot
    brightnessctl
    playerctl
    overskride
    bluetui
    impala
    pavucontrol
    apple-cursor
    lm_sensors
    wlogout
    networkmanagerapplet
    networkmanager_dmenu
    psmisc
    libnotify # For notify-send testing
  ];

  imports = [
    ./rofi.nix
    ./waybar.nix
    ./hyprlock.nix
    ./hyprpaper.nix
    ./hypridle.nix
    ./mako.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua";
    settings = {
      fileManager._var = fileManager;
      mainMod._var = "SUPER";
      menu._var = menu;
      shiftMod._var = lua ''mainMod .. " + SHIFT"'';
      terminal._var = terminal;

      monitor = [
        {
          output = laptopMonitor;
          mode = "1920x1080@60.05";
          position = "0x0";
          scale = 1;
        }
        {
          output = homeMonitor;
          mode = "1920x1080@75";
          position = "0x-1080";
          scale = 1;
        }
        {
          output = workMonitor;
          mode = "2560x1440@59.95";
          position = "1920x-360";
          scale = 1;
        }
      ];

      workspace_rule = [
        {
          workspace = "1";
          monitor = laptopMonitor;
        }
        {
          workspace = "2";
          monitor = laptopMonitor;
        }
        {
          workspace = "3";
          monitor = laptopMonitor;
        }
        {
          workspace = "4";
          monitor = homeMonitor;
        }
        {
          workspace = "5";
          monitor = homeMonitor;
        }
        {
          workspace = "6";
          monitor = homeMonitor;
        }
        {
          workspace = "7";
          monitor = workMonitor;
        }
        {
          workspace = "8";
          monitor = workMonitor;
        }
        {
          workspace = "9";
          monitor = workMonitor;
        }
        {
          workspace = "10";
          monitor = workMonitor;
        }
      ];

      on = call [
        "hyprland.start"
        (lua ''
          function()
            hl.exec_cmd("gnome-keyring-daemon --start --components=secrets")
            hl.exec_cmd(terminal)
            hl.exec_cmd("waybar")
            hl.exec_cmd("hyprpaper")
            hl.exec_cmd("hypridle")
            hl.exec_cmd("thunderbird")
          end
        '')
      ];

      env = [
        (call [
          "XCURSOR_SIZE"
          "24"
        ])
        (call [
          "HYPRCURSOR_SIZE"
          "24"
        ])
        (call [
          "XCURSOR_THEME"
          "macOS-White"
        ])
        (call [
          "HYPRCURSOR_THEME"
          "macOS-White"
        ])
      ];

      config = {
        general = {
          gaps_in = 5;
          gaps_out = 5;
          border_size = 1;
          col = {
            active_border = {
              colors = [
                "rgba(33ccffee)"
                "rgba(00ff99ee)"
              ];
              angle = 45;
            };
            inactive_border = "rgba(595959aa)";
          };
          resize_on_border = false;
          allow_tearing = false;
          layout = "dwindle";
        };

        decoration = {
          rounding = 10;
          active_opacity = 1.0;
          inactive_opacity = 1.0;
          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
          blur = {
            enabled = true;
            size = 3;
            passes = 1;
            vibrancy = 0.1696;
          };
        };

        animations.enabled = true;

        dwindle.preserve_split = true;

        master.new_status = "master";

        misc = {
          force_default_wallpaper = 0;
          disable_hyprland_logo = true;
        };

        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";
          follow_mouse = 1;
          natural_scroll = true;
          sensitivity = 0;
          touchpad.natural_scroll = true;
        };
      };

      curve = [
        (call [
          "easeOutQuint"
          {
            type = "bezier";
            points = [
              [
                0.23
                1
              ]
              [
                0.32
                1
              ]
            ];
          }
        ])
        (call [
          "easeInOutCubic"
          {
            type = "bezier";
            points = [
              [
                0.65
                0.05
              ]
              [
                0.36
                1
              ]
            ];
          }
        ])
        (call [
          "linear"
          {
            type = "bezier";
            points = [
              [
                0
                0
              ]
              [
                1
                1
              ]
            ];
          }
        ])
        (call [
          "almostLinear"
          {
            type = "bezier";
            points = [
              [
                0.5
                0.5
              ]
              [
                0.75
                1.0
              ]
            ];
          }
        ])
        (call [
          "quick"
          {
            type = "bezier";
            points = [
              [
                0.15
                0
              ]
              [
                0.1
                1
              ]
            ];
          }
        ])
      ];

      animation = [
        {
          leaf = "global";
          enabled = true;
          speed = 10;
          bezier = "default";
        }
        {
          leaf = "border";
          enabled = true;
          speed = 5.39;
          bezier = "easeOutQuint";
        }
        {
          leaf = "windows";
          enabled = true;
          speed = 4.79;
          bezier = "easeOutQuint";
        }
        {
          leaf = "windowsIn";
          enabled = true;
          speed = 4.1;
          bezier = "easeOutQuint";
          style = "popin 87%";
        }
        {
          leaf = "windowsOut";
          enabled = true;
          speed = 1.49;
          bezier = "linear";
          style = "popin 87%";
        }
        {
          leaf = "fadeIn";
          enabled = true;
          speed = 1.73;
          bezier = "almostLinear";
        }
        {
          leaf = "fadeOut";
          enabled = true;
          speed = 1.46;
          bezier = "almostLinear";
        }
        {
          leaf = "fade";
          enabled = true;
          speed = 3.03;
          bezier = "quick";
        }
        {
          leaf = "layers";
          enabled = true;
          speed = 3.81;
          bezier = "easeOutQuint";
        }
        {
          leaf = "layersIn";
          enabled = true;
          speed = 4;
          bezier = "easeOutQuint";
          style = "fade";
        }
        {
          leaf = "layersOut";
          enabled = true;
          speed = 1.5;
          bezier = "linear";
          style = "fade";
        }
        {
          leaf = "fadeLayersIn";
          enabled = true;
          speed = 1.79;
          bezier = "almostLinear";
        }
        {
          leaf = "fadeLayersOut";
          enabled = true;
          speed = 1.39;
          bezier = "almostLinear";
        }
        {
          leaf = "workspaces";
          enabled = true;
          speed = 1.94;
          bezier = "almostLinear";
          style = "fade";
        }
        {
          leaf = "workspacesIn";
          enabled = true;
          speed = 1.21;
          bezier = "almostLinear";
          style = "fade";
        }
        {
          leaf = "workspacesOut";
          enabled = true;
          speed = 1.94;
          bezier = "almostLinear";
          style = "fade";
        }
      ];

      gesture = {
        fingers = 3;
        direction = "horizontal";
        action = "workspace";
      };

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      bind = [
        (bind (lua ''mainMod .. " + Q"'') "hl.dsp.window.close()")
        (bind (lua ''mainMod .. " + W"'') "hl.dsp.window.close()")
        (bind (lua ''mainMod .. " + CTRL + Q"'') ''hl.dsp.exec_cmd("loginctl lock-session")'')
        (bind (lua ''mainMod .. " + ALT + L"'') ''hl.dsp.exec_cmd("loginctl lock-session")'')
        (bind (lua ''shiftMod .. " + Q"'') "hl.dsp.exit()")
        (bind (lua ''mainMod .. " + E"'') "hl.dsp.exec_cmd(fileManager)")
        (bind (lua ''mainMod .. " + M"'') ''hl.dsp.window.float({ action = "toggle" })'')
        (bind (lua ''mainMod .. " + SPACE"'') "hl.dsp.exec_cmd(menu)")
        (bind (lua ''mainMod .. " + X"'') ''hl.dsp.send_shortcut({ mods = "CTRL", key = "X", window = "activewindow" })'')
        (bind (lua ''mainMod .. " + C"'') ''hl.dsp.send_shortcut({ mods = "CTRL", key = "C", window = "activewindow" })'')
        (bind (lua ''mainMod .. " + V"'') ''hl.dsp.send_shortcut({ mods = "CTRL", key = "V", window = "activewindow" })'')
        (bind (lua ''mainMod .. " + P"'') "hl.dsp.window.pseudo()")
        (bind (lua ''mainMod .. " + G"'') ''hl.dsp.layout("togglesplit")'')
        (bind (lua ''mainMod .. " + H"'') ''hl.dsp.focus({ direction = "left" })'')
        (bind (lua ''mainMod .. " + L"'') ''hl.dsp.focus({ direction = "right" })'')
        (bind (lua ''mainMod .. " + K"'') ''hl.dsp.focus({ direction = "up" })'')
        (bind (lua ''mainMod .. " + J"'') ''hl.dsp.focus({ direction = "down" })'')
        (bind (lua ''mainMod .. " + 1"'') "hl.dsp.focus({ workspace = 1 })")
        (bind (lua ''mainMod .. " + 2"'') "hl.dsp.focus({ workspace = 2 })")
        (bind (lua ''mainMod .. " + 3"'') "hl.dsp.focus({ workspace = 3 })")
        (bind (lua ''mainMod .. " + 4"'') "hl.dsp.focus({ workspace = 4 })")
        (bind (lua ''mainMod .. " + 5"'') "hl.dsp.focus({ workspace = 5 })")
        (bind (lua ''mainMod .. " + 6"'') "hl.dsp.focus({ workspace = 6 })")
        (bind (lua ''mainMod .. " + 7"'') "hl.dsp.focus({ workspace = 7 })")
        (bind (lua ''mainMod .. " + 8"'') "hl.dsp.focus({ workspace = 8 })")
        (bind (lua ''mainMod .. " + 9"'') "hl.dsp.focus({ workspace = 9 })")
        (bind (lua ''mainMod .. " + 0"'') "hl.dsp.focus({ workspace = 10 })")
        (bind (lua ''mainMod .. " + CTRL + 1"'') "hl.dsp.window.move({ workspace = 1 })")
        (bind (lua ''mainMod .. " + CTRL + 2"'') "hl.dsp.window.move({ workspace = 2 })")
        (bind (lua ''mainMod .. " + CTRL + 3"'') "hl.dsp.window.move({ workspace = 3 })")
        (bind (lua ''mainMod .. " + CTRL + 4"'') "hl.dsp.window.move({ workspace = 4 })")
        (bind (lua ''mainMod .. " + CTRL + 5"'') "hl.dsp.window.move({ workspace = 5 })")
        (bind (lua ''mainMod .. " + CTRL + 6"'') "hl.dsp.window.move({ workspace = 6 })")
        (bind (lua ''mainMod .. " + CTRL + 7"'') "hl.dsp.window.move({ workspace = 7 })")
        (bind (lua ''mainMod .. " + CTRL + 8"'') "hl.dsp.window.move({ workspace = 8 })")
        (bind (lua ''mainMod .. " + CTRL + 9"'') "hl.dsp.window.move({ workspace = 9 })")
        (bind (lua ''mainMod .. " + CTRL + 0"'') "hl.dsp.window.move({ workspace = 10 })")
        (bind (lua ''mainMod .. " + Left"'') ''hl.dsp.focus({ workspace = "e-1" })'')
        (bind (lua ''mainMod .. " + Right"'') ''hl.dsp.focus({ workspace = "e+1" })'')
        (bind (lua ''mainMod .. " + S"'') ''hl.dsp.workspace.toggle_special("magic")'')
        (bind (lua ''shiftMod .. " + S"'') ''hl.dsp.window.move({ workspace = "special:magic" })'')
        (bind (lua ''mainMod .. " + mouse_down"'') ''hl.dsp.focus({ workspace = "e+1" })'')
        (bind (lua ''mainMod .. " + mouse_up"'') ''hl.dsp.focus({ workspace = "e-1" })'')
        (bind (lua ''shiftMod .. " + 3"'') ''hl.dsp.exec_cmd("hyprshot -m output")'')
        (bind (lua ''shiftMod .. " + 4"'') ''hl.dsp.exec_cmd("hyprshot -m region")'')
        (bind (lua ''shiftMod .. " + 5"'') ''hl.dsp.exec_cmd("hyprshot -m window")'')
        (bind (lua ''mainMod .. " + F"'') "hl.dsp.window.fullscreen()")
        (bind (lua ''mainMod .. " + TAB"'') "hl.dsp.window.cycle_next()")
        (bind (lua ''shiftMod .. " + Tab"'') "hl.dsp.window.cycle_next({ next = false })")
        (bind (lua ''shiftMod .. " + E"'') ''hl.dsp.exec_cmd("wlogout")'')
        (bindWith "XF86AudioRaiseVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+")'' {
          locked = true;
          repeating = true;
        })
        (bindWith "XF86AudioLowerVolume" ''hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-")'' {
          locked = true;
          repeating = true;
        })
        (bindWith "XF86AudioMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle")'' {
          locked = true;
          repeating = true;
        })
        (bindWith "XF86AudioMicMute" ''hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle")'' {
          locked = true;
          repeating = true;
        })
        (bindWith "XF86MonBrightnessUp" ''hl.dsp.exec_cmd("brightnessctl s 10%+")'' {
          locked = true;
          repeating = true;
        })
        (bindWith "XF86MonBrightnessDown" ''hl.dsp.exec_cmd("brightnessctl s 10%-")'' {
          locked = true;
          repeating = true;
        })
        (bindWith "XF86AudioNext" ''hl.dsp.exec_cmd("playerctl next")'' { locked = true; })
        (bindWith "XF86AudioPause" ''hl.dsp.exec_cmd("playerctl play-pause")'' { locked = true; })
        (bindWith "XF86AudioPlay" ''hl.dsp.exec_cmd("playerctl play-pause")'' { locked = true; })
        (bindWith "XF86AudioPrev" ''hl.dsp.exec_cmd("playerctl previous")'' { locked = true; })
        (bindWith (lua ''mainMod .. " + mouse:272"'') "hl.dsp.window.drag()" { mouse = true; })
        (bindWith (lua ''mainMod .. " + mouse:273"'') "hl.dsp.window.resize()" { mouse = true; })
      ];

      window_rule = [
        # Assign applications to specific workspaces
        {
          workspace = 1;
          match.class = "com.mitchellh.ghostty";
        }

        # Thunderbird Main Window - only workspace assignment
        {
          workspace = 2;
          match = {
            class = "^thunderbird$";
            initial_title = "^Mozilla Thunderbird$";
          };
        }

        # Thunderbird Reminder Window - float, center, size, and workspace 2
        {
          workspace = 2;
          float = true;
          center = true;
          size = "600 400";
          match = {
            class = "^thunderbird$";
            initial_title = "^Calendar Reminders$";
          };
        }

        {
          workspace = 4;
          match.class = "zen-twilight";
        }
        {
          workspace = 5;
          match.class = "dev.zed.Zed";
        }
        {
          workspace = 6;
          match.class = "Code";
        }
        {
          suppress_event = "maximize";
          match.class = ".*";
        }
        {
          no_focus = true;
          match = {
            class = "^$";
            title = "^$";
            xwayland = true;
            float = true;
            fullscreen = false;
            pin = false;
          };
        }
      ];
    };
  };
}
