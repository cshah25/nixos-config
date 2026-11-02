{
  config,
  lib,
  pkgs,
  ...
}:

let
  art = import ./artwork.nix { inherit lib; };
  inherit (art)
    arms
    armPath
    armFill
    logoSvg
    logoBox
    ;

  # Logo canvas padded by 30% on each side, leaving room for the blur to fall off
  glowBox = "-150.47 -150.47 802.5 802.5";

  svgs =
    lib.listToAttrs (
      lib.imap0 (k: arm: {
        name = "arm-${toString k}";
        value = logoSvg {
          viewBox = logoBox;
          body = armPath (armFill arm) arm;
        };
      }) arms
      ++ lib.imap0 (k: arm: {
        name = "shine-${toString k}";
        value = logoSvg {
          viewBox = logoBox;
          body = armPath "#eaf4ff" arm;
        };
      }) arms
    )
    // {
      glow = logoSvg {
        viewBox = glowBox;
        body = lib.concatMapStrings (armPath "#7ebae4") arms;
      };
      halo = ''
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
          <defs>
            <radialGradient id="g">
              <stop offset="0" stop-color="#5277c3" stop-opacity="0.30"/>
              <stop offset="0.35" stop-color="#4a6baf" stop-opacity="0.12"/>
              <stop offset="0.7" stop-color="#415e9a" stop-opacity="0.03"/>
              <stop offset="1" stop-color="#415e9a" stop-opacity="0"/>
            </radialGradient>
          </defs>
          <rect width="100" height="100" fill="url(#g)"/>
        </svg>
      '';
      bar = ''
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 4">
          <defs>
            <linearGradient id="g">
              <stop offset="0" stop-color="#5277c3"/>
              <stop offset="1" stop-color="#7ebae4"/>
            </linearGradient>
          </defs>
          <rect width="400" height="4" rx="2" fill="url(#g)"/>
        </svg>
      '';
      track = ''
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 400 4">
          <rect width="400" height="4" rx="2" fill="#ffffff" fill-opacity="0.07"/>
        </svg>
      '';
      field = ''
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 360 48">
          <rect x="1" y="1" width="358" height="46" rx="23"
            fill="#ffffff" fill-opacity="0.04"
            stroke="#7ebae4" stroke-opacity="0.45" stroke-width="1.5"/>
        </svg>
      '';
      bullet = ''
        <svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 12 12">
          <circle cx="6" cy="6" r="5" fill="#cfe4f7"/>
        </svg>
      '';
    };

  # Logo layers come in two sizes so the script never has to shrink an image
  # far (plymouth only interpolates); everything else is rendered once
  sizes = {
    halo = 512;
    bar = 800;
    track = 800;
    field = 720;
    bullet = 24;
  };
  logoWidths = {
    sm = 320;
    lg = 640;
  };

  render =
    name: svg:
    let
      src = pkgs.writeText "${name}.svg" svg;
      # The glow canvas is 1.6x the logo's, so it lines up when scaled to match
      glowScale = if name == "glow" then 1.6 else 1;
    in
    if sizes ? ${name} then
      ''
        rsvg-convert -w ${toString sizes.${name}} ${src} -o $dir/${name}.png
      ''
    else
      lib.concatStrings (
        lib.mapAttrsToList (suffix: w: ''
          rsvg-convert -w ${toString (builtins.floor (w * glowScale))} ${src} -o $dir/${name}-${suffix}.png
        '') logoWidths
      );

  theme =
    pkgs.runCommand "plymouth-nixos-snowflake"
      {
        nativeBuildInputs = [
          pkgs.librsvg
          pkgs.imagemagick
        ];
      }
      ''
        dir=$out/share/plymouth/themes/nixos-snowflake
        mkdir -p $dir

        ${lib.concatStrings (lib.mapAttrsToList render svgs)}

        # Soften the glow into a halo around the snowflake
        magick $dir/glow-sm.png -channel A -blur 0x14 +channel $dir/glow-sm.png
        magick $dir/glow-lg.png -channel A -blur 0x28 +channel $dir/glow-lg.png

        cp ${./nixos-snowflake.script} $dir/nixos-snowflake.script
        cat > $dir/nixos-snowflake.plymouth <<EOF
        [Plymouth Theme]
        Name=NixOS Snowflake
        Description=The NixOS snowflake assembling from its six lambdas
        ModuleName=script

        [script]
        ImageDir=$dir
        ScriptFile=$dir/nixos-snowflake.script
        EOF
      '';
in
{
  # Pond ships its own boot theme (see ../boot.nix)
  config.boot = lib.mkIf (config.sys.desktop.shell != "pond") {
    plymouth = {
      enable = true;
      theme = "nixos-snowflake";
      themePackages = [ theme ];
    };

    # Keep kernel and initrd chatter off the splash
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "splash"
      "udev.log_level=3"
      "rd.systemd.show_status=auto"
    ];
  };
}
