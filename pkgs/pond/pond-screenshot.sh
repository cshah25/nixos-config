#!/usr/bin/env bash
# pond-screenshot region|screen: save to ~/Pictures/Screenshots, copy it, and
# hand it to the shell's preview (niri reports its own screenshots instead).
set -euo pipefail

dir="${XDG_PICTURES_DIR:-$HOME/Pictures}/Screenshots"
file="$dir/Screenshot from $(date '+%Y-%m-%d %H-%M-%S').png"
mkdir -p "$dir"

case "${1:-region}" in
  region) grim -g "$(slurp -d)" "$file" ;;
  screen) grim "$file" ;;
  *) echo "usage: pond-screenshot region|screen" >&2; exit 2 ;;
esac

wl-copy --type image/png < "$file"
pond-msg screenshot captured "$file" >/dev/null 2>&1 \
  || notify-send -i "$file" "Screenshot saved" "$(basename "$file")"
