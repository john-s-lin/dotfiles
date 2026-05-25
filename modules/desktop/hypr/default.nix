{
  pkgs,
  ...
}:
let
  terminal = "ghostty";
  fileManager = "cosmic-files";
  menu = "rofi -show drun";
  secondMonitor = "DP-2";
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
      "$mainMod" = "SUPER";
      "$shiftMod" = "$mainMod + SHIFT";
      "$terminal" = terminal;
      "$fileManager" = fileManager;
      "$menu" = menu;

      monitor = [
        "eDP-1,1920x1080@60.05,0x0,1"
        "${secondMonitor},1920x1080@75,0x-1080,1"
      ];

      # Assign workspaces to monitors
      workspace = [
        "1, monitor:eDP-1"
        "2, monitor:eDP-1"
        "3, monitor:eDP-1"
        "4, monitor:${secondMonitor}"
        "5, monitor:${secondMonitor}"
        "6, monitor:${secondMonitor}"
      ];

      exec-once = [
        "gnome-keyring-daemon --start --components=secrets"
        terminal
        "waybar"
        "hyprpaper"
        "hypridle"

        # Apps that I want open
        "thunderbird"
      ];

      env = [
        "XCURSOR_SIZE,24"
        "HYPRCURSOR_SIZE,24"
        "XCURSOR_THEME,macOS-White"
        "HYPRCURSOR_THEME,macOS-White"
      ];

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 1;
        "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
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

      animations = {
        enabled = "yes, please :)";
        bezier = [
          "easeOutQuint,0.23,1,0.32,1"
          "easeInOutCubic,0.65,0.05,0.36,1"
          "linear,0,0,1,1"
          "almostLinear,0.5,0.5,0.75,1.0"
          "quick,0.15,0,0.1,1"
        ];
        animation = [
          "global, 1, 10, default"
          "border, 1, 5.39, easeOutQuint"
          "windows, 1, 4.79, easeOutQuint"
          "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
          "windowsOut, 1, 1.49, linear, popin 87%"
          "fadeIn, 1, 1.73, almostLinear"
          "fadeOut, 1, 1.46, almostLinear"
          "fade, 1, 3.03, quick"
          "layers, 1, 3.81, easeOutQuint"
          "layersIn, 1, 4, easeOutQuint, fade"
          "layersOut, 1, 1.5, linear, fade"
          "fadeLayersIn, 1, 1.79, almostLinear"
          "fadeLayersOut, 1, 1.39, almostLinear"
          "workspaces, 1, 1.94, almostLinear, fade"
          "workspacesIn, 1, 1.21, almostLinear, fade"
          "workspacesOut, 1, 1.94, almostLinear, fade"
        ];
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        new_status = "master";
      };

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
        touchpad = {
          natural_scroll = true;
        };
      };

      gesture = "3, horizontal, workspace";

      device = {
        name = "epic-mouse-v1";
        sensitivity = -0.5;
      };

      bind = [
        "$mainMod, Q, killactive,"
        "$mainMod, W, killactive,"
        "$mainMod CTRL, Q, exec, loginctl lock-session"
        "$mainMod ALT, L, exec, loginctl lock-session"
        "$mainMod SHIFT, Q, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, M, togglefloating,"
        "$mainMod, SPACE, exec, $menu"
        "$mainMod, X, sendshortcut, ctrl, x"
        "$mainMod, C, sendshortcut, ctrl, c"
        "$mainMod, V, sendshortcut, ctrl, v"
        "$mainMod, P, pseudo,"
        "$mainMod, G, togglesplit,"
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod CTRL, 1, movetoworkspace, 1"
        "$mainMod CTRL, 2, movetoworkspace, 2"
        "$mainMod CTRL, 3, movetoworkspace, 3"
        "$mainMod CTRL, 4, movetoworkspace, 4"
        "$mainMod CTRL, 5, movetoworkspace, 5"
        "$mainMod CTRL, 6, movetoworkspace, 6"
        "$mainMod CTRL, 7, movetoworkspace, 7"
        "$mainMod CTRL, 8, movetoworkspace, 8"
        "$mainMod CTRL, 9, movetoworkspace, 9"
        "$mainMod CTRL, 0, movetoworkspace, 10"
        "$mainMod, Left, workspace, e-1"
        "$mainMod, Right, workspace, e+1"
        "$mainMod, S, togglespecialworkspace, magic"
        "$mainMod SHIFT, S, movetoworkspace, special:magic"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod SHIFT, 3, exec, hyprshot -m output"
        "$mainMod SHIFT, 4, exec, hyprshot -m region"
        "$mainMod SHIFT, 5, exec, hyprshot -m window"
        "$mainMod, F, fullscreen"
        "$mainMod, TAB, cyclenext"
        "$mainMod SHIFT, Tab, cyclenext, prev"
        "$mainMod SHIFT, E, exec, wlogout"
      ];

      bindel = [
        ",XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
      ];

      bindl = [
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrule = [
        # Assign applications to specific workspaces
        "workspace 1, match:class com.mitchellh.ghostty"

        # Thunderbird Main Window - only workspace assignment
        "workspace 2, match:class ^thunderbird$, match:initial_title ^Mozilla Thunderbird$"

        # Thunderbird Reminder Window - float, center, size, and workspace 2
        "workspace 2, match:class ^thunderbird$, match:initial_title ^Calendar Reminders$"
        "float on, match:class ^thunderbird$, match:initial_title ^Calendar Reminders$"
        "center on, match:class ^thunderbird$, match:initial_title ^Calendar Reminders$"
        "size 600 400, match:class ^thunderbird$, match:initial_title ^Calendar Reminders$"

        "workspace 4, match:class zen-twilight"
        "workspace 5, match:class dev.zed.Zed"
        "workspace 6, match:class Code"
        "suppress_event maximize, match:class .*"
        "no_focus on, match:class ^$, match:title ^$, match:xwayland 1, match:float 1, match:fullscreen 0, match:pin 0"
      ];
    };
  };
}
