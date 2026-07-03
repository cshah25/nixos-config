{
  services.printing.enable = true;
  
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
