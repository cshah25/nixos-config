# Pond's boot art: the Plymouth boot/shutdown/restart animation, and a Limine wallpaper
# made from the flower on Pond's GRUB theme (Limine can't load GRUB themes).
{
  stdenvNoCC,
  imagemagick,
}:

stdenvNoCC.mkDerivation {
  pname = "pond-boot";
  version = "0-unstable-2026-11-01";

  src = ./boot;

  nativeBuildInputs = [ imagemagick ];

  installPhase = ''
    runHook preInstall

    theme=$out/share/plymouth/themes/pond
    mkdir -p $theme
    cp -r plymouth/assets plymouth/pond.script $theme/
    substitute plymouth/pond.plymouth $theme/pond.plymouth \
      --replace-fail /usr/share/plymouth/themes/pond $theme

    # 4K canvas in Pond's plum, flower in the bottom-left corner as on the GRUB menu
    mkdir -p $out/share/pond
    magick -size 3840x2160 xc:'#1c0919' flower.png -gravity southwest -composite \
      $out/share/pond/limine-wallpaper.png

    runHook postInstall
  '';
}
