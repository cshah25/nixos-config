{ config, pkgs, hostname, ... }:

{
  xdg.configFile = {
    "mango/config.conf".source = ./dotfiles/mango/config.conf;
    "mango/cfg/env.conf".source = ./dotfiles/mango/cfg/env.conf;
    "mango/cfg/autostart.conf".source = ./dotfiles/mango/cfg/autostart.conf;
    "mango/cfg/input.conf".source = ./dotfiles/mango/cfg/input.conf;
    "mango/cfg/layout.conf".source = ./dotfiles/mango/cfg/layout.conf;
    "mango/cfg/rules.conf".source = ./dotfiles/mango/cfg/rules.conf;
    "mango/cfg/bind.conf".source = ./dotfiles/mango/cfg/bind.conf;

    "mango/cfg/display.conf".text = if hostname == "NixHome" then ''
      # NixHome dual 4K monitor configuration
      monitorrule=name:DP-3,width:3840,height:2160,refresh:144,scale:1.5,x:0,y:0
      monitorrule=name:DP-2,width:3840,height:2160,refresh:60,scale:1.5,x:2560,y:0
    '' else if hostname == "NixPrecision" then ''
      # NixPrecision Dell laptop display
      monitorrule=name:eDP-1,width:1920,height:1200,refresh:60,scale:1,x:0,y:1080
    '' else if hostname == "NixThinkpad" then ''
      # NixThinkpad Lenovo laptop display
      monitorrule=name:eDP-1,width:1920,height:1200,refresh:60,scale:1,x:0,y:1080
    '' else "";
  };
}
