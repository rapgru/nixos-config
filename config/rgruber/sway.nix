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
          modifier-win = "Mod4";
          modifier-alt = "Mod1";
        in
          lib.mkOptionDefault {
            "XF86AudioRaiseVolume" = "exec pulsemixer --change-volume +5";
            "XF86AudioLowerVolume" = "exec pulsemixer --change-volume -5";
            "XF86MonBrightnessUp" = "exec brillo -A 5";
            "XF86MonBrightnessDown" = "exec brillo -U 5";
            "${modifier-win}+shift+g" = ''exec grim -g "$(slurp)" - | wl-copy --type image/png'';
            "${modifier-alt}+tab" = "workspace back_and_forth";
          };
        modifier = "Mod4";
        assigns = {
          "1:www" = [{ class = "^Vivaldi-stable$"; } { app_id = "firefox"; }];
          "8:mail" = [{ app_id = "thunderbird"; }];
          "9:comm" = [{ class = "discord"; } { class = "Microsoft Teams - Preview";}];
        };
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.wofi}/bin/wofi --show drun";
        gaps.inner = 5;
        gaps.smartGaps = true;
        startup = [
          { command = "systemctl --user import-environment"; }
          { command = "systemctl --user start graphical-session.target"; }
          {
            command = "firefox";
          }
          {
            command = "thunderbird";
          }
          {
            command = ''"sleep 5; Discord"'';
          }
          {
            command = "teams";
          }
          { 
            command = ''
              swayidle -w \
    timeout 300  'swaylock --screenshots --effect-blur 5x7 --effect-vignette 0.5:0.5 --ring-color 6B0504 --key-hl-color A3320B --fade-in 0.2 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --clock --indicator' \
    timeout 600  'swaymsg "output * dpms off"' \
    resume       'swaymsg "output * dpms on"' \
    before-sleep 'swaylock --screenshots --effect-blur 5x7 --effect-vignette 0.5:0.5 --ring-color 6B0504 --key-hl-color A3320B --fade-in 0.2 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --clock --indicator' \
    lock         'swaylock --screenshots --effect-blur 5x7 --effect-vignette 0.5:0.5 --ring-color 6B0504 --key-hl-color A3320B --fade-in 0.2 --line-color 00000000 --inside-color 00000088 --separator-color 00000000 --clock --indicator'
            '';
          }
        ];
        bars = [
          {
            command = "${pkgs.waybar}/bin/waybar"; 
          }
        ];
      };
      extraConfig = ''
        workspace "1:www" output DP-1
        workspace 2 output DP-1
        workspace 3 output DP-1
        workspace 4 output DP-1
        workspace "8:mail" output eDP-1
        workspace "9:comm" output eDP-1
        for_window [app_id="thunderbird"] floating enable
        for_window [class="discord"] layout stacking
      '';
    }; 
    programs.waybar = {
      enable = true;
      settings = [
        {
          layer = "top";
          position = "bottom";
          height = 30;
          modules-left = [ "sway/workspaces" "tray" "custom/performancemode"];
          modules-center = [ ]; 
          modules-right = [ "network" "cpu" "memory" "disk" "battery" "battery#bat2" "pulseaudio" "clock"];
          modules = {
            "sway/workspaces" = {
              all-outputs = false;
              disable-scroll = true;
              format = "{icon} {name}";
              format-icons = {
                "1:www" = ""; # Icon: firefox-browser
                "8:mail" = ""; # Icon: mail
                "9:comm" = ""; # Icon: code
                "urgent" = "";
                "focused" = "";
                "default" = "";
              };
            };
            #"sway/window" = {
            #  format = "{}";
            #  max-length = 120;
            #};
            cpu = {
              format = " {usage}%";
              interval = 1;
              tooltip = false;
            };
            battery = {
              bat = "BAT1";
              interval = 30;
              states = {
                warning = 30;
                critical = 15;
              };
              format = " {capacity}%";
              format-charging = " {capacity}% ";
              format-plugged = " {capacity}% ";
              #format-alt = " {time} {icon}";
              #format-icons = ["" "" "" "" ""];
              tooltip = true;
            };
            "battery#bat2" = {
              bat = "BAT2";
              interval = 30;
              states = {
                warning = 30;
                critical = 15;
              };
              format = " {capacity}%";
              format-charging = " {capacity}% ";
              format-plugged = " {capacity}% ";
              #format-alt = " {time} {icon}";
              tooltip = true;
            };
            "custom/performancemode" = {
              exec = "${pkgs.custom-waybar-scripts}/bin/surface-mode.sh";
              return-type = "json";
              interval = 30;
              exec-on-event = true;
              format = "{icon}";
              format-icons = {
                "1" = "";
                "2" = "";
                "3" = "";
                "4" = "";
              };
              on-click = "${pkgs.custom-waybar-scripts}/bin/surface-mode.sh increase; pkill -SIGRTMIN+8 waybar";
              on-scroll-up = "${pkgs.custom-waybar-scripts}/bin/surface-mode.sh increase; pkill -SIGRTMIN+8 waybar";
              on-scroll-down = "${pkgs.custom-waybar-scripts}/bin/surface-mode.sh decrease; pkill -SIGRTMIN+8 waybar";
              signal = 8;
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
              format-bluetooth = "{volume}% {icon}";
              format-muted = "";
              format-icons = {
                headphones = "";
                handsfree = "";
                headset = "";
                phone = "";
                portable = "";
                car = "";
                default = [ "" "" ];
              };
            };
            clock = {
              format = " {:%d.%m.%Y %T}";
              interval = 5;
              tooltip = false;
            };
            disk = {
              interval = 180;
              format = " {free}";
              path = "/";
            };
            memory = {
              interval = 30;
              format = " {used:0.1f} GiB";
              tooltip = false;
            };
            network = {
              tooltip-format-wifi = " {essid} {ipaddr} at {signalStrength}%";
              format-wifi = " {essid}";
              format-ethernet = " {ipaddr}/{cidr}";
              format-disconnected = "";
              on-click = "nmtui";
            };
          };
        }
      ];
      style = ''
        @keyframes blink-warning {
          70% {
            color: #FBFFFE;
          }

          to {
            color: #FBFFFE;
            background-color: #E6AF2E;
          }
        }

        @keyframes blink-critical {
          70% {
            color: #FBFFFE;
          }

          to {
            color: #FBFFFE;
            background-color: #A3320B;
          }
        }

        * {
          border: none;
          border-radius: 0;
          min-height: 0;
          margin: 0;
          padding: 0;
        }

        #waybar {
          background: #001514;
          font-family: sans-serif;
          font-size: 13px;
          color: #FBFFFE;
        }

        #battery,
        #clock,
        #cpu,
        #custom-keyboard-layout,
        #memory,
        #mode,
        #network,
        #pulseaudio,
        #temperature,
        #disk,
        #custom-performancemode,
        #tray {
          padding-left: 10px;
          padding-right: 10px;
        }

        #battery, battery.bat2 {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #battery.warning, battery.bat2.warning {
          color: #E6AF2E;
        }

        #battery.critical, battery.bat2.critical {
          color: #A3320B;
        }

        #battery.warning.discharging, battery.bat2.warning.discharging {
          animation-name: blink-warning;
          animation-duration: 3s;
        }

        #battery.critical.discharging, battery.bat2.critical.discharging {
          animation-name: blink-critical;
          animation-duration: 2s;
        }

        #clock {
          font-weight: bold;
        }

        #cpu {
          /* No styles */
        }

        #cpu.warning {
          color: #E6AF2E;
        }

        #cpu.critical {
          color: #A3320B;
        }

        #memory {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #memory.warning {
          color: #E6AF2E;
        }

        #memory.critical {
          color: #A3320B;
          animation-name: blink-critical;
          animation-duration: 2s;
        }

        #network.disconnected {
          color: #E6AF2E;
        }

        #workspaces button {
          border-top: 2px solid transparent;
          /* To compensate for the top border and still have vertical centering */
          padding-bottom: 2px;
          padding-left: 10px;
          padding-right: 10px;
          color: #888888;
        }

        #workspaces button.focused {
          border-color: #4c7899;
          color: #FBFFFE;
          background-color: #285577;
        }

        #workspaces button.urgent {
          border-color: #c9545d;
          color: #c9545d;
        }

      '';
    };
    home.packages = with pkgs; [
      swaylock-effects
      swayidle
      wl-clipboard
      mako
      wofi 
      sway-run
      grim # screenshots
      slurp # select region 
    ];
}
