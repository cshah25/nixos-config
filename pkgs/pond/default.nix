# Pond desktop shell, adapted from bflycomputer/pond-interface (BSD-3-Clause, see LICENSE)
# at f77883588cf0b27bc4c5fa5c0ee2dc1814a448a6, with a mango backend beside niri's.
{
  lib,
  stdenv,
  fetchurl,
  cmake,
  pkg-config,
  makeWrapper,
  qt6,
  kdePackages,
  wayland,
  quickshell,
  python3,
  gobject-introspection,
  glib,
  gdk-pixbuf,
  networkmanager,
  iw,
  ddcutil,
  brightnessctl,
  zenity,
  pulseaudio,
  fastfetch,
  wl-clipboard,
  wlopm,
  grim,
  slurp,
  libnotify,
  vicinae,
  coreutils,
  getent,
}:

let
  python = python3.withPackages (ps: [ ps.pygobject3 ]);

  # Tools the shell and its Python helpers call by name
  runtimePath = lib.makeBinPath [
    quickshell
    python
    networkmanager
    iw
    ddcutil
    brightnessctl
    zenity
    pulseaudio
    fastfetch
    wl-clipboard
    wlopm
    vicinae
    coreutils
    getent
  ];

  googleFont =
    path: hash:
    fetchurl {
      name = baseNameOf (lib.replaceStrings [ "%5B" "%5D" "," ] [ "" "" "-" ] path);
      url = "https://raw.githubusercontent.com/google/fonts/4c1db3aec83c67dd223dd82a68c039cab30917a9/ofl/${path}";
      inherit hash;
    };
in
stdenv.mkDerivation {
  pname = "pond";
  version = "0-unstable-2026-11-01";

  # Boot art is its own package (boot.nix); leave it out so it doesn't rebuild the shell
  src = lib.fileset.toSource {
    root = ./.;
    fileset = lib.fileset.difference ./. (
      lib.fileset.unions [
        ./boot
        ./boot.nix
      ]
    );
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    makeWrapper
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    kdePackages.networkmanager-qt
    networkmanager
    glib
    wayland
  ];

  # The only executables are the quickshell wrappers below
  dontWrapQtApps = true;

  postInstall = ''
    share=$out/share/pond
    qml=$out/lib/qt-6/qml

    wrap() {
      local name=$1
      shift
      makeWrapper ${lib.getExe' quickshell "qs"} "$out/bin/$name" \
        --prefix PATH : ${runtimePath} \
        --prefix QML_IMPORT_PATH : "$qml" \
        --prefix GI_TYPELIB_PATH : ${
          lib.makeSearchPath "lib/girepository-1.0" [
            glib.out
            gdk-pixbuf
            gobject-introspection
          ]
        } \
        "$@"
    }

    # pond-shell: run the shell; pond-msg <target> <fn> [args]: call its IPC
    wrap pond-shell --add-flags "-p $share/shell"
    wrap pond-msg --add-flags "-p $share/shell ipc call"
    wrap .pond-lockscreen --add-flags "-p $share/lockscreen"

    # pond-lock: lock through a running lockscreen instance, or start one
    cat > $out/bin/pond-lock <<EOF
    #!${stdenv.shell}
    $out/bin/.pond-lockscreen ipc call lockscreen lock 2>/dev/null || exec $out/bin/.pond-lockscreen -d
    EOF
    chmod +x $out/bin/pond-lock

    # pond-screenshot region|screen: capture, copy, and show Pond's preview
    # (niri does this itself; this is for mango and other wlroots compositors)
    makeWrapper ${./pond-screenshot.sh} $out/bin/pond-screenshot \
      --prefix PATH : ${
        lib.makeBinPath [
          grim
          slurp
          wl-clipboard
          libnotify
          coreutils
        ]
      }:$out/bin

    install -Dm644 ${googleFont "onest/Onest%5Bwght%5D.ttf" "sha256-lmxcKbR1XahLaFTVwh3U6qJCAiXQ6YdN5gLeF21KnzE="} \
      $out/share/fonts/truetype/Onest.ttf
    install -Dm644 ${googleFont "newsreader/Newsreader%5Bopsz,wght%5D.ttf" "sha256-igjRP4psDVG+N5pgr4T5RfZTaaZ+UJ7jw73MQhJU18E="} \
      $out/share/fonts/truetype/Newsreader.ttf
    install -Dm644 ${googleFont "newsreader/Newsreader-Italic%5Bopsz,wght%5D.ttf" "sha256-eWZoYR+Atk1a3xgv3jtvKe2DtOfL7HuWk36ErAE2R5I="} \
      $out/share/fonts/truetype/Newsreader-Italic.ttf
    install -Dm644 ${googleFont "adventpro/AdventPro%5Bwdth,wght%5D.ttf" "sha256-tgqykguJvcS32t+ygsraxuA4M+eoCET56sCWNZsrl2Y="} \
      $out/share/fonts/truetype/AdventPro.ttf
  '';

  meta = {
    description = "Pond desktop shell for niri and mango";
    homepage = "https://github.com/bflycomputer/pond-interface";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
  };
}
