{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}:
{
  # OneDrive mount via rclone
  systemd.user.services.rclone-onedrive-mount = lib.mkIf osConfig.sys.services.onedrive.enable {
    Unit = {
      Description = "Mount OneDrive via rclone";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "notify";
      # Create the local mount directory if it doesn't exist
      ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p %h/OneDrive";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount \
          --vfs-cache-mode writes \
          --vfs-cache-max-age 24h \
          --vfs-cache-max-size 10G \
          --dir-cache-time 1m \
          --allow-other \
          OneDrive: %h/OneDrive
      '';
      ExecStop = "/run/wrappers/bin/fusermount -u %h/OneDrive";
      Restart = "on-failure";
      RestartSec = "10s";
      Environment = [ "PATH=/run/wrappers/bin:$PATH" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };

  # Nextcloud mount via rclone
  systemd.user.services.nextcloud-mount = lib.mkIf osConfig.sys.services.nextcloud-mount.enable {
    Unit = {
      Description = "Mount Nextcloud via rclone";
      After = [ "network-online.target" ];
      Wants = [ "network-online.target" ];
    };

    Service = {
      Type = "notify";
      ExecStart = ''
        ${pkgs.rclone}/bin/rclone mount \
          --vfs-cache-mode full \
          --vfs-cache-max-age 24h \
          --vfs-cache-max-size 10G \
          nextcloud: /mnt/Nextcloud
      '';
      ExecStop = "/run/wrappers/bin/fusermount3 -u /mnt/Nextcloud";
      Restart = "on-failure";
      RestartSec = "10s";
      Environment = [ "PATH=/run/wrappers/bin:$PATH" ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}
