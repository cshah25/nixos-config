{ config, pkgs, ... }:

let
  mergePdfsScript = pkgs.writeShellScript "merge-pdfs" ''
    set -euo pipefail

    NOTIFY="${pkgs.libnotify}/bin/notify-send"
    QPDF="${pkgs.qpdf}/bin/qpdf"

    # Require at least one file
    if [ $# -eq 0 ]; then
      "$NOTIFY" -u critical "Merge PDFs" "No files selected."
      exit 1
    fi

    # Validate every selected file is a PDF
    for f in "$@"; do
      lower=''${f,,}
      if [[ "$lower" != *.pdf ]]; then
        "$NOTIFY" -u critical "Merge PDFs" "Not a PDF: $(basename "$f")"
        exit 1
      fi
    done

    # Choose a collision-safe output path next to the first selected file
    dir="$(dirname "$1")"
    base="merged"
    outfile="$dir/$base.pdf"
    i=1
    while [ -e "$outfile" ]; do
      outfile="$dir/$base-$i.pdf"
      i=$((i + 1))
    done

    "$NOTIFY" "Merge PDFs" "Merging $# files..."

    # Use qpdf which handles restricted/encrypted PDFs much better than pdfunite
    if "$QPDF" --empty --pages "$@" -- "$outfile" > /tmp/merge-pdfs.log 2>&1; then
      "$NOTIFY" "Merge PDFs" "Created $(basename "$outfile")"
    else
      "$NOTIFY" -u critical "Merge PDFs" "Failed to merge PDFs. See /tmp/merge-pdfs.log"
      exit 1
    fi
  '';
in
{
  # Thunar Custom Actions (uca.xml)
  home.file.".config/Thunar/uca.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <actions>
    <action>
      <icon>utilities-terminal</icon>
      <name>Open Terminal Here</name>
      <submenu></submenu>
      <unique-id>1786725824088131-1</unique-id>
      <command>exo-open --working-directory %f --launch TerminalEmulator</command>
      <description>Example for a custom action</description>
      <range></range>
      <patterns>*</patterns>
      <startup-notify/>
      <directories/>
    </action>
    <action>
      <icon>document-pdf</icon>
      <name>Merge PDFs</name>
      <submenu>PDF</submenu>
      <unique-id>merge-pdfs-1</unique-id>
      <command>${mergePdfsScript} %F</command>
      <description>Merge selected PDFs</description>
      <range></range>
      <patterns>*.pdf;*.PDF</patterns>
      <other-files/>
      <text-files/>
    </action>
    </actions>
  '';
}

