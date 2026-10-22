{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.sys.hardware.ddc.enable = lib.mkEnableOption "DDC/CI monitor control (ddcutil)";

  config = lib.mkMerge [
    {
      hardware.bluetooth.enable = true;

      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
      };

      services.logind.settings.Login.HandlePowerKey = "ignore";
      services.power-profiles-daemon.enable = true;
    }

    (lib.mkIf config.sys.hardware.ddc.enable {
      hardware.i2c.enable = true;
      environment.systemPackages = [ pkgs.ddcutil ];
    })
  ];
}
