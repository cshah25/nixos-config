{ pkgs, ... }:

{
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_ENABLE_WAYLAND = "1";
  };

  environment.systemPackages = with pkgs; [
    sbctl
    vim
    git
    curl
    wget
    tree
    alacritty
    distrobox
    bat
    tmux
    fastfetch
    noctalia-shell
    swayidle
    brightnessctl
    playerctl
    (catppuccin-papirus-folders.override {
      flavor = "mocha";
      accent = "mauve";
    })
    adwaita-icon-theme
    xwayland-satellite
    python3
    cmake
    ninja
    gcc
    gnumake
    ripgrep
    wayland-pipewire-idle-inhibit
  ];
}
