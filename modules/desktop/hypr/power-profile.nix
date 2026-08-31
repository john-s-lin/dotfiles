{ lib, pkgs, ... }:
let
  powerProfileMenu = pkgs.writeShellApplication {
    name = "power-profile-menu";
    text = ''
      current=$(${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} get)
      case "$current" in
        performance) selected=" Performance" ;;
        balanced) selected=" Balanced" ;;
        power-saver) selected=" Power Saver" ;;
      esac

      profile=$(printf '%s\n' " Performance" " Balanced" " Power Saver" | ${lib.getExe pkgs.rofi} -dmenu -no-custom -p "Power profile" -select "$selected")

      case "$profile" in
        " Performance") ${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} set performance ;;
        " Balanced") ${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} set balanced ;;
        " Power Saver") ${lib.getExe' pkgs.power-profiles-daemon "powerprofilesctl"} set power-saver ;;
      esac
    '';
  };
in
{
  home.packages = [ powerProfileMenu ];

  xdg.desktopEntries.power-profile-menu = {
    name = "Power Profiles";
    comment = "Select the system power profile";
    exec = lib.getExe powerProfileMenu;
    icon = "battery";
    categories = [
      "Settings"
      "System"
    ];
    terminal = false;
  };
}
