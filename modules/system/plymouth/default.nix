{ lib, pkgs, ... }:

let
  # Lambda arm from the official nix-snowflake.svg (nixos-icons), with its
  # original transforms so the rendered logo matches upstream exactly
  lambda = "m 309.54892,-710.38827 122.19683,211.67512 -56.15706,0.5268 -32.6236,-56.8692 -32.85645,56.5653 -27.90237,-0.011 -14.29086,-24.6896 46.81047,-80.4901 -33.22946,-57.8257 z";

  # Arm k sits at k * 60deg clockwise; dark and light alternate
  arms = [
    {
      rot = "";
      dark = true;
    }
    {
      rot = "rotate(60,407.11155,-715.78724)";
      dark = false;
    }
    {
      rot = "rotate(120,407.33916,-716.08356)";
      dark = true;
    }
    {
      rot = "rotate(180,407.41868,-715.7565)";
      dark = false;
    }
    {
      rot = "rotate(-120,407.28823,-715.86995)";
      dark = true;
    }
    {
      rot = "rotate(-60,407.31177,-715.70016)";
      dark = false;
    }
  ];

  gradients = ''
    <linearGradient id="light" gradientUnits="userSpaceOnUse"
      gradientTransform="translate(70.650339,-1055.1511)"
      x1="200.59668" y1="351.41116" x2="290.08701" y2="506.18814">
      <stop offset="0" stop-color="#699ad7"/>
      <stop offset="0.243" stop-color="#7eb1dd"/>
      <stop offset="1" stop-color="#7ebae4"/>
    </linearGradient>
    <linearGradient id="dark" gradientUnits="userSpaceOnUse"
      gradientTransform="translate(864.69589,-1491.3405)"
      x1="-584.19934" y1="782.33563" x2="-496.29703" y2="937.71399">
      <stop offset="0" stop-color="#415e9a"/>
      <stop offset="0.232" stop-color="#4a6baf"/>
      <stop offset="1" stop-color="#5277c3"/>
    </linearGradient>
  '';

  # Every arm image shares the full logo canvas, so all sprites stack at one origin
  logoSvg =
    { viewBox, body }:
    ''
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="${viewBox}">
        <defs>${gradients}</defs>
        <g transform="translate(-156.41121,933.30685)">
          <g transform="matrix(0.99994059,0,0,0.99994059,-0.06321798,33.188377)">
            ${body}
          </g>
        </g>
      </svg>
    '';

  armPath =
    fill: arm: ''<path d="${lambda}" fill="${fill}" fill-rule="evenodd" transform="${arm.rot}"/>'';

  armFill = arm: if arm.dark then "url(#dark)" else "url(#light)";

  logoBox = "0 0 501.56251 501.56249";
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
  boot = {
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
