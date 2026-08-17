{ pkgs, config, ... }:
let
  homeDir = config.users.users.${config.system.primaryUser}.home;
  mounts = {
    rclone-onedrive = {
      remote = "OneDrive:";
      path = "${homeDir}/OneDrive";
    };
    rclone-gdrive = {
      remote = "GDrive:";
      path = "${homeDir}/GDrive";
    };
  };
in
{
  environment.systemPackages = with pkgs; [
    rclone
  ];

  homebrew = {
    casks = [ "macfuse" ];
  };

  launchd.user.agents = builtins.mapAttrs (name: mount: {
    serviceConfig = {
      ProgramArguments = [
        "/bin/sh"
        "-c"
        "mkdir -p ${mount.path} && ${pkgs.rclone}/bin/rclone --vfs-cache-mode writes --noappledouble --noapplexattr --config=${homeDir}/.config/rclone/rclone.conf --ignore-checksum mount ${mount.remote} ${mount.path}"
      ];
      RunAtLoad = true;
      KeepAlive = {
        Crashed = true;
        SuccessfulExit = false;
      };
      StandardOutPath = "${homeDir}/Library/Logs/${name}.log";
      StandardErrorPath = "${homeDir}/Library/Logs/${name}.err.log";
    };
  }) mounts;
}
