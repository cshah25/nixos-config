{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.sys.boot.theme;
  art = import ./artwork.nix { inherit lib; };

  dims = map lib.toInt (lib.splitString "x" cfg.resolution);
  width = builtins.elemAt dims 0;
  height = builtins.elemAt dims 1;
  # Limine's 8x16 font is unreadably small at 4K; double it there
  hiDpi = height >= 2000;

  # Layout, in fractions of the screen height. Limine centres the menu
  # vertically, so the logo and wordmark sit in the band above it.
  logoSize = 0.17 * height;
  logoY = 0.225 * height;
  wordmarkY = 0.365 * height;
  hintY = 0.94 * height;

  num = x: toString (builtins.floor x);
  centreX = width / 2.0;
  logoScale = logoSize / art.logoExtent;
  # Places logoBox so its centre lands on (centreX, logoY) at logoSize
  logoTransform = "translate(${toString (centreX - logoSize / 2)},${
    toString (logoY - logoSize / 2)
  }) scale(${toString logoScale})";

  wallpaperSvg = pkgs.writeText "limine-wallpaper.svg" ''
    <svg xmlns="http://www.w3.org/2000/svg" width="${toString width}" height="${toString height}"
      viewBox="0 0 ${toString width} ${toString height}">
      <defs>
        ${art.gradients}
        <linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">
          <stop offset="0" stop-color="#11141f"/>
          <stop offset="1" stop-color="#07080d"/>
        </linearGradient>
        <radialGradient id="halo" gradientUnits="userSpaceOnUse"
          cx="${num centreX}" cy="${num logoY}" r="${num (0.75 * height)}">
          <stop offset="0" stop-color="#5277c3" stop-opacity="0.26"/>
          <stop offset="0.3" stop-color="#4a6baf" stop-opacity="0.09"/>
          <stop offset="0.65" stop-color="#415e9a" stop-opacity="0.02"/>
          <stop offset="1" stop-color="#415e9a" stop-opacity="0"/>
        </radialGradient>
        <filter id="blur" x="-50%" y="-50%" width="200%" height="200%">
          <feGaussianBlur stdDeviation="${toString (art.logoExtent * 0.07)}"/>
        </filter>
      </defs>

      <rect width="100%" height="100%" fill="url(#sky)"/>
      <rect width="100%" height="100%" fill="url(#halo)"/>

      <g transform="${logoTransform}">
        <g filter="url(#blur)" opacity="0.55">
          ${art.logoGroup (lib.concatMapStrings (art.armPath "#7ebae4") art.arms)}
        </g>
        ${art.logoGroup art.fullLogo}
      </g>

      <text x="${num centreX}" y="${num wordmarkY}" text-anchor="middle"
        font-family="Noto Sans" font-weight="300" font-size="${num (0.024 * height)}"
        letter-spacing="${num (0.012 * height)}" fill="#d1e3f7" fill-opacity="0.8">NixOS</text>

      <text x="${num centreX}" y="${num hintY}" text-anchor="middle"
        font-family="Noto Sans" font-size="${num (0.0135 * height)}"
        letter-spacing="${num (0.002 * height)}" fill="#9fc3e8" fill-opacity="0.35" xml:space="preserve">↑ ↓  select      ⏎  boot</text>
    </svg>
  '';

  wallpaper =
    pkgs.runCommand "limine-nixos-snowflake-${cfg.resolution}.png"
      {
        nativeBuildInputs = [
          pkgs.librsvg
          pkgs.imagemagick
        ];
        FONTCONFIG_FILE = pkgs.makeFontsConf { fontDirectories = [ pkgs.noto-fonts ]; };
      }
      ''
        rsvg-convert ${wallpaperSvg} -o wall.png
        # A touch of noise dithers the dark gradients so they don't band
        magick wall.png -attenuate 0.12 +noise Gaussian -strip $out
      '';
in
{
  options.sys.boot.theme.resolution = lib.mkOption {
    type = lib.types.strMatching "[0-9]+x[0-9]+";
    default = "1920x1080";
    description = "Native resolution of the boot display; the Limine wallpaper is rendered at exactly this size.";
  };

  # Pond ships its own boot theme (see ../boot.nix)
  config.boot.loader.limine = lib.mkIf (config.sys.desktop.shell != "pond") {
    # Keeps the centred menu short enough to clear the logo
    maxGenerations = lib.mkDefault 10;

    style = {
      wallpapers = [ wallpaper ];
      wallpaperStyle = "stretched";
      backdrop = "07080D";

      interface = {
        inherit (cfg) resolution;
        # The wallpaper carries the wordmark; a blank branding keeps the default out
        branding = " ";
        helpHidden = true;
      };

      graphicalTerminal = {
        font.scale = lib.mkIf hiDpi "2x2";
        # Fully transparent, so text sits straight on the wallpaper. The selected
        # entry is drawn reversed: a solid foreground bar with the text cut out.
        background = "FF000000";
        foreground = "9FC3E8";
        brightForeground = "EAF4FF";
        margin = 0;
        marginGradient = 0;
        palette = "11141F;E06C75;98C379;E5C07B;5277C3;C678DD;7EBAE4;9FC3E8";
        brightPalette = "3B4261;FF7A85;B5E890;FFD58A;7AA2F7;D7A6F0;A6D8F5;EAF4FF";
      };
    };
  };
}
