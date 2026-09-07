{
  config,
  lib,
  pkgs,
  mkDot,
  ...
}: let
  c = config.themePalette;
in {
  home.packages = [pkgs.waybar];

  xdg.configFile."waybar/config-sway.jsonc".source = mkDot "waybar/config-sway.jsonc";
  xdg.configFile."waybar/style.css".text = ''
    * {
      font-family: "JetBrainsMono Nerd Font";
      font-size: 12px;
      border: none;
      border-radius: 0;
    }

    window#waybar {
      background-color: ${c.panel};
      color: ${c.fg};
    }

    window#waybar.hidden {
      opacity: 0.2;
    }

    .modules-left > widget:first-child {
      margin-left: 12px;
    }

    .modules-right > widget:last-child {
      margin-right: 12px;
    }

    #workspaces {
      background: transparent;
    }

    #workspaces button {
      min-width: 20px;
      padding: 0 4px;
      color: ${c.fg};
      background: transparent;
    }

    #workspaces button.focused {
      color: ${c.accent};
    }

    #workspaces button.empty {
      opacity: 0.5;
    }

    #workspaces button.urgent {
      color: ${c.normal.red};
    }

    #battery,
    #clock {
      padding: 0 8px;
      color: ${c.fg};
    }

    #battery.critical,
    #battery.warning {
      color: ${c.normal.red};
    }

    #clock {
      padding: 0 10px;
    }

    tooltip {
      background-color: ${c.panel};
      border: 1px solid ${c.muted};
    }

    tooltip label {
      color: ${c.fg};
    }
  '';
}
