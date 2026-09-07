#!/usr/bin/env bash
# Theme switch handler for $mod+Shift+c.
#
# Reloads the (rebuilt) sway config so waybar / wallpaper / borders pick up
# the new palette, then retheme every running Ghostty window by injecting
# ghostty's built-in `reload_config` keybinding (ctrl+shift+,) while each
# surface is focused. Requires wtype (sway's virtual keyboard protocol).

prev="$(swaymsg -t get_tree | jq -r '.. | objects | select(.focused? == true) | .id' | head -n1)"

swaymsg reload

mapfile -t targets < <(swaymsg -t get_tree |
  jq -r '.. | objects |
    select(.app_id? == "com.mitchellh.ghostty") |
    .id')

for id in "${targets[@]}"; do
  swaymsg "[con_id=${id}]" focus
  sleep 0.1
  wtype -M ctrl -M shift -k comma -m ctrl -m shift
  sleep 0.05
done

if [ -n "$prev" ]; then
  swaymsg "[con_id=${prev}]" focus
fi