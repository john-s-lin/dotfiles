{ pkgs, config, ... }:
let
  rcloneConfig = "${config.xdg.configHome}/rclone/rclone.conf";
  mounts = {
    rclone-gdrive = {
      description = "rclone mount for Google Drive";
      remote = "gdrive:";
      path = "${config.home.homeDirectory}/GDrive";
    };
    rclone-onedrive = {
      description = "rclone mount for OneDrive";
      remote = "onedrive:";
      path = "${config.home.homeDirectory}/OneDrive";
    };
  };
in
{
  home.packages = with pkgs; [
    rclone
    fuse3
  ];

  systemd.user.services = builtins.mapAttrs (_: mount: {
    Unit = {
      Description = mount.description;
      After = [ "network-online.target" ];
    };

    Service = {
      Type = "notify";
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p ${mount.path}";
      ExecStart = "${pkgs.rclone}/bin/rclone --vfs-cache-mode writes --ignore-checksum --config=${rcloneConfig} mount ${mount.remote} ${mount.path}";
      ExecStop = "${pkgs.fuse3}/bin/fusermount -u ${mount.path}";
      Restart = "on-failure";
      RestartSec = 10;
    };
    Install = {
      WantedBy = [ "default.target" ];
    };
  }) mounts;
}
