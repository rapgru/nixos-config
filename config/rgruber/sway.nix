{ lib, pkgs, ... }:

{
    wayland.windowManager.sway = {
      enable = true;
      #package = null;
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;
      systemdIntegration = false;
      config = {
        output = {
          eDP-1 = {
            resolution = "3000x2000"; 
            scale = "2";
            position = "0,1080";
          };
          # Samsung Full HD Monitor
          DP-1 = {
            resolution = "1920x1080";
            scale = "1";
            position = "0,0";
          };
        };
        input = { 
          "1118:2338:Microsoft_Surface_Keyboard_Touchpad" = {
            natural_scroll = "enabled";
            tap = "enabled";
            click_method = "clickfinger";
            scroll_method = "two_finger";
            drag = "enabled";
          };
          "1118:2338:Microsoft_Surface_Keyboard" = {
            xkb_layout = "us";
            xkb_variant = "intl";
          };
        };
        keybindings = let
        in
          lib.mkOptionDefault {
            "XF86AudioRaiseVolume" = "exec pulsemixer --change-volume +5";
            "XF86AudioLowerVolume" = "exec pulsemixer --change-volume -5";
          };
        modifier = "Mod4";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.wofi}/bin/wofi --show drun";
        gaps.inner = 5;
        gaps.smartGaps = true;
        startup = [
          #{
          #  command = "systemctl --user restart swaybar";
          #  always = true;
          #}
        ];
        bars = [
          {
            command = "${pkgs.waybar}/bin/waybar"; 
          }
        ];
      };
    }; 
    programs.waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          position = "top";
          height = 30;
          modules-left = [ "clock" "pulseaudio" "tray" ];
          modules-center = [ "sway/workspaces" ]; 
          modules-right = [ "network" "cpu" "memory" "disk" ];
          modules = {
            "sway/workspaces" = {
              all-outputs = true;
              "persistent_workspaces" = {
                "1" = [];
                "2" = [];
                "3" = [];
                "4" = [];
                "5" = [];
                "6" = [];
                "7" = [];
                "8" = [];
                "9" = [];
              }; 
            };
            cpu = {
              format = "{usage}%";
              interval = 1;
              tooltip = false;
            };
            tray = {
              spacing = 5;
              icon-size = 14;
              tooltip = false;
            };
            pulseaudio = {
              tooltip = false;
              on-click = "pulsemixer";
              format = "{volume}% {icon}";
            };
            clock = {
              format = "{:%d.%m.%Y %T}";
              interval = 5;
            };
            disk = {
              interval = 180;
              format = "{free}";
              path = "/";
            };
            memory = {
              interval = 30;
              format = "{used:0.1f} GiB";
            };
            network = {
              format-wifi = "{essid} at {signalStrength}%";
              format-ethernet = "Wired {ipaddr}";
              format-disconnected = "Disconnected";
              on-click = "nmtui";
            };
          };
        }
      ];
    };
    home.packages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      wofi 
      sway-run
    ];
}
