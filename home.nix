{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "rayu";
  home.homeDirectory = "/home/rayu";
  #home-manager.backupFileExtension = "backup";
  # KDE Connect
  services.kdeconnect.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "25.11"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.nerd-fonts.meslo-lg
    pkgs.teams-for-linux
    pkgs.vscode
    pkgs.antigravity
    pkgs.libreoffice
    pkgs.android-studio
    pkgs.nextcloud-client
    pkgs.brave
    pkgs.spotify
    pkgs.equibop
    pkgs.obsidian
    pkgs.heroic
    pkgs.nodejs
    pkgs.xev
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/rayu/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
  programs.neovim.enable = true;
  xdg.configFile = {
	"alacritty".source = ./dotfiles/alacritty;
	"gtk-3.0".source = ./dotfiles/gtk-3.0;
	"gtk-4.0".source = ./dotfiles/gtk-4.0;
	"Kvantum".source = ./dotfiles/Kvantum;
	"niri".source = ./dotfiles/niri;
	"qt5ct".source = ./dotfiles/qt5ct;
  "nvim".source = ./dotfiles/nvim;
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "image/png" = [ "org.kde.gwenview.desktop" ];
      "image/jpeg" = [ "org.kde.gwenview.desktop" ];
      "image/jpg" = [ "org.kde.gwenview.desktop" ];
      "image/gif" = [ "org.kde.gwenview.desktop" ];
      "image/webp" = [ "org.kde.gwenview.desktop" ];
    };
  };

  dconf.enable = true;
  gtk.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "docker"
      ];
    };

    plugins = [
      {
        name = "powerlevel10k";
        src = pkgs.zsh-powerlevel10k;
        file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
      }
    ];

    initContent = ''
      # Sourcing the p10k configuration file if it exists
      [[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

      pybox() {
        # Check if the first argument ($1) is empty
        if [[ -z "$1" ]]; then
            echo "Error: No target directory provided."
            echo "Usage: pybox <path-to-project-folder>"
            return 1
        fi

        local target_dir="$1"

        # Enter the box, change directory, activate the venv, and keep the shell open
        distrobox enter python312-box -- bash -c "cd $target_dir && source .venv/bin/activate && exec bash"
      }
    '';
  };
}
