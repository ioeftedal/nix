#!/usr/bin/env bash
# Dunst-based OSD for media and brightness keys. Replaces swayosd:
# volume/mute via wpctl (PipeWire), brightness via brightnessctl,
# player controls via playerctl. Bound from home/sway.nix.
set -euo pipefail

SINK="@DEFAULT_AUDIO_SINK@"
DEV="intel_backlight"
NOTIFY_OPTS=(-a osd -t 1500 -u low)

volnotify() {
  local out pct
  out="$(wpctl get-volume "$SINK")"
  pct="$(awk '{printf "%.0f\n", $2*100}' <<<"$out")"
  if grep -q 'MUTED' <<<"$out"; then
    dunstify "${NOTIFY_OPTS[@]}" -r 9901 "Volume muted"
  else
    dunstify "${NOTIFY_OPTS[@]}" -r 9901 -h "int:value:$pct" "Volume $pct%"
  fi
}

brightnotify() {
  local cur max pct
  cur="$(brightnessctl -d "$DEV" get)"
  max="$(brightnessctl -d "$DEV" max)"
  pct=$((cur * 100 / max))
  dunstify "${NOTIFY_OPTS[@]}" -r 9902 -h "int:value:$pct" "Brightness $pct%"
}

case "${1:-}" in
  vol)
    case "${2:-}" in
      mute) wpctl set-mute "$SINK" toggle ;;
      +*) wpctl set-volume "$SINK" "${2#+}%+" ;;
      -*) wpctl set-volume "$SINK" "${2#-}%-" ;;
      *) wpctl set-volume "$SINK" "${2}%" ;;
    esac
    volnotify
    ;;
  mic)
    wpctl set-mute "@DEFAULT_AUDIO_SOURCE@" toggle
    ;;
  bright)
    case "${2:-}" in
      +*) brightnessctl -d "$DEV" set "${2#+}%+" >/dev/null ;;
      -*) brightnessctl -d "$DEV" set "${2#-}%-" >/dev/null ;;
      *) brightnessctl -d "$DEV" set "${2}%" >/dev/null ;;
    esac
    brightnotify
    ;;
  next) playerctl next ;;
  play-pause) playerctl play-pause ;;
  previous) playerctl previous ;;
  *)
    echo "usage: $0 {vol|mic|bright (mute|<N[+-]>)} | {next|play-pause|previous}" >&2
    exit 1
    ;;
esac