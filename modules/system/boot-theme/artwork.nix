# Shared NixOS snowflake artwork for the Limine and Plymouth themes
{ lib }:

rec {
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

  # The logo's own coordinate system: its 501.56 x 501.56 box starts at (0, 0)
  logoBox = "0 0 501.56251 501.56249";
  logoExtent = 501.56251;

  # Maps upstream path coordinates into logoBox
  logoGroup = body: ''
    <g transform="translate(-156.41121,933.30685)">
      <g transform="matrix(0.99994059,0,0,0.99994059,-0.06321798,33.188377)">
        ${body}
      </g>
    </g>
  '';

  logoSvg =
    { viewBox, body }:
    ''
      <svg xmlns="http://www.w3.org/2000/svg" viewBox="${viewBox}">
        <defs>${gradients}</defs>
        ${logoGroup body}
      </svg>
    '';

  armPath =
    fill: arm: ''<path d="${lambda}" fill="${fill}" fill-rule="evenodd" transform="${arm.rot}"/>'';

  armFill = arm: if arm.dark then "url(#dark)" else "url(#light)";

  fullLogo = lib.concatMapStrings (arm: armPath (armFill arm) arm) arms;
}
