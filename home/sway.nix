{
  config,
  lib,
  pkgs,
  mkDot,
  ...
}: let
  c = config.themePalette;
  # swaylock colors are bare RRGGBB (no '#'), so strip the leading '#'.
  sub = builtins.substring;
in {
  home.packages = with pkgs; [
    # --unsupported-gpu: NVIDIA+Wayland need this to silence WLR's refusal to
    # start on a non-EGL-supported GPU setup; purely a driver-workaround flag.
    (sway.override {extraOptions = ["--unsupported-gpu"];})
    swaylock
    wlsunset
    fuzzel
    numlockx
    autotiling-rs
    wtype
    jq
  ];

  home.file."bin/ghostty-reload" = {
    source = mkDot "scripts/ghostty-reload.sh";
    executable = true;
  };

  xdg.configFile."sway/config".text = ''
    input type:pointer {
        accel_profile flat
        pointer_accel 0
        natural_scroll enabled
    }

    input type:touchpad {
        natural_scroll enabled
        tap enabled
        tap_button_map lrm
    }

    input "type:keyboard" {
        xkb_layout us
        xkb_options ctrl:nocaps
        repeat_rate 90
        repeat_delay 250
    }

    output * bg ${c.wallpaper} fill
    output * scale 1.2
    # Both external monitors are 2560x1440 at scale 1.2 -> 2133 logical px wide.
    # DP-6 is left (pos 0 0), DP-8 is right (pos 2133 0). Positions are in
    # logical pixels; the two must not overlap or windows will bleed across.
    output DP-6 pos 0 0
    output DP-8 pos 2133 0

    # Appearance
    default_border pixel 2
    default_floating_border pixel 2
    gaps inner 3
    gaps outer 5
    smart_gaps off
    smart_borders off
    hide_edge_borders none

    client.focused          ${c.active} ${c.active} ${c.active} ${c.active}
    client.focused_inactive ${c.bright.black}aa ${c.bright.black}aa ${c.bright.black}aa ${c.bright.black}aa
    client.unfocused        ${c.bright.black}aa ${c.bright.black}aa ${c.bright.black}aa ${c.bright.black}aa
    client.urgent           ${c.normal.red} ${c.normal.red} ${c.normal.red} ${c.normal.red}
    client.background       ${c.bg}

    workspace_auto_back_and_forth yes

    # Window commands
    for_window [class="^$"][title="^$"][app_id="^$"][app_id=".*xwayland.*"] no_focus

    # Autostart (skip cursor commands handled by home-manager / XDGConfig)
    exec dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec systemctl --user import-environment WAYLAND_DISPLAY XDG_CURRENT_DESKTOP

    exec_always setcursor Adwaita 16

    exec numlockx on

    exec autotiling-rs

    exec ghostty
    exec dunst
    exec swayosd-server
    exec wlsunset -l 54.0 -L -1.0
    exec_always bash -c 'pkill waybar 2>/dev/null; sleep 0.2; exec waybar -c ~/.config/waybar/config-sway.jsonc'
    exec firefox

    # Modifier
    set $mod Super

    # Applications
    bindsym $mod+Return exec ghostty
    bindsym $mod+Space exec fuzzel
    bindsym $mod+R exec fuzzel
    bindsym $mod+Shift+Return exec firefox
    bindsym $mod+W kill
    bindsym $mod+F fullscreen
    bindsym $mod+V floating toggle
    bindsym $mod+P split toggle
    bindsym $mod+M exit

    # Focus
    bindsym $mod+h focus left
    bindsym $mod+j focus down
    bindsym $mod+k focus up
    bindsym $mod+l focus right

    # Move
    bindsym $mod+Shift+h move left
    bindsym $mod+Shift+j move down
    bindsym $mod+Shift+k move up
    bindsym $mod+Shift+l move right

    # Workspaces
    set $ws1  1
    set $ws2  2
    set $ws3  3
    set $ws4  4
    set $ws5  5
    set $ws6  6
    set $ws7  7
    set $ws8  8
    set $ws9  9
    set $ws10 10

    workspace 1 output DP-6
    workspace 2 output DP-8
    workspace 0 output eDP-1

    bindsym $mod+1 workspace number $ws1
    bindsym $mod+2 workspace number $ws2
    bindsym $mod+3 workspace number $ws3
    bindsym $mod+4 workspace number $ws4
    bindsym $mod+5 workspace number $ws5
    bindsym $mod+6 workspace number $ws6
    bindsym $mod+7 workspace number $ws7
    bindsym $mod+8 workspace number $ws8
    bindsym $mod+9 workspace number $ws9
    bindsym $mod+0 workspace number $ws10

    bindsym $mod+Shift+1 move container to workspace number $ws1
    bindsym $mod+Shift+2 move container to workspace number $ws2
    bindsym $mod+Shift+3 move container to workspace number $ws3
    bindsym $mod+Shift+4 move container to workspace number $ws4
    bindsym $mod+Shift+5 move container to workspace number $ws5
    bindsym $mod+Shift+6 move container to workspace number $ws6
    bindsym $mod+Shift+7 move container to workspace number $ws7
    bindsym $mod+Shift+8 move container to workspace number $ws8
    bindsym $mod+Shift+9 move container to workspace number $ws9
    bindsym $mod+Shift+0 move container to workspace number $ws10

    # Scratchpad
    bindsym $mod+S scratchpad show
    bindsym $mod+Shift+S move scratchpad

    # Mouse bindings
    bindsym $mod+button3 move
    bindsym $mod+button4 workspace next
    bindsym $mod+button5 workspace prev

    # Scroll through workspaces with mouse
    bindsym --whole-window $mod+button4 workspace next
    bindsym --whole-window $mod+button5 workspace prev

    # Media keys
    bindsym XF86AudioRaiseVolume exec swayosd-client --output-volume +5
    bindsym XF86AudioLowerVolume exec swayosd-client --output-volume -5
    bindsym XF86AudioMute exec swayosd-client --output-volume mute-toggle
    bindsym XF86AudioMicMute exec swayosd-client --input-volume mute-toggle
    bindsym XF86MonBrightnessUp exec swayosd-client --device intel_backlight --brightness +5
    bindsym XF86MonBrightnessDown exec swayosd-client --device intel_backlight --brightness -5
    bindsym Shift+XF86MonBrightnessUp exec swayosd-client --device intel_backlight --brightness +100
    bindsym Shift+XF86MonBrightnessDown exec swayosd-client --device intel_backlight --brightness -100
    bindsym Alt+XF86MonBrightnessUp exec swayosd-client --device intel_backlight --brightness +1
    bindsym Alt+XF86MonBrightnessDown exec swayosd-client --device intel_backlight --brightness -1
    bindsym Alt+XF86AudioRaiseVolume exec swayosd-client --output-volume +1
    bindsym Alt+XF86AudioLowerVolume exec swayosd-client --output-volume -1
    bindsym XF86AudioNext exec swayosd-client --playerctl next
    bindsym XF86AudioPause exec swayosd-client --playerctl play-pause
    bindsym XF86AudioPlay exec swayosd-client --playerctl play-pause
    bindsym XF86AudioPrev exec swayosd-client --playerctl previous

    # Reload config / apply theme switch (reloads sway + rethemes ghostty)
    bindsym $mod+Shift+c exec ${config.home.homeDirectory}/bin/ghostty-reload

    # Lock
    bindsym $mod+Ctrl+l exec swaylock
  '';

  xdg.configFile."swaylock/config".text = ''
    daemonize
    show-failed-attempts
    color=${sub 1 6 c.bg}
    font=JetBrains Mono

    # Screenshot blur
    inside-color=00000088
    line-color=00000000
    separator-color=00000000

    # Ring colors
    ring-color=${sub 1 6 c.muted}ee
    ring-ver-color=${sub 1 6 c.active}ee
    ring-wrong-color=${sub 1 6 c.normal.red}ee
    ring-clear-color=${sub 1 6 c.bright.yellow}ee

    # Text colors
    text-color=${sub 1 6 c.fg}
    text-ver-color=${sub 1 6 c.fg}
    text-wrong-color=${sub 1 6 c.normal.red}
    text-clear-color=${sub 1 6 c.bright.yellow}

    # Key press
    key-hl-color=${sub 1 6 c.muted}ee
    bs-hl-color=${sub 1 6 c.normal.red}ee

    # Inside of input field
    inside-color=${sub 1 6 c.fg}22
    line-ver-color=${sub 1 6 c.active}ee
    line-wrong-color=${sub 1 6 c.normal.red}ee
    line-clear-color=${sub 1 6 c.bright.yellow}ee
  '';
}
