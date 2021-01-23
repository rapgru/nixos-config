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
            "XF86MonBrightnessUp" = "exec brillo -A 5";
            "XF86MonBrightnessDown" = "exec brillo -U 5";
            "Mod4+shift+g" = ''exec grim -g "$(slurp)" - | wl-copy -t image'';
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
          position = "bottom";
          height = 30;
          modules-left = [ "sway/workspaces" "tray" "pulseaudio" "custom/performancemode"];
          modules-center = [ "sway/window" ]; 
          modules-right = [ "network" "cpu" "memory" "disk" "battery" "battery#bat2" "clock"];
          modules = {
            "sway/workspaces" = {
              all-outputs = false;
              disable-scroll = true;
              format = "{icon} {name}";
              format-icons = {
                "1:www" = "龜"; # Icon: firefox-browser
                "2:mail" = ""; # Icon: mail
                "3:editor" = ""; # Icon: code
                "4:terminals" = ""; # Icon: terminal
                "5:portal" = ""; # Icon: terminal
                "urgent" = "";
                "focused" = "";
                "default" = "";
              };
            };
            "sway/window" = {
              format = "{}";
              max-length = 120;
            };
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
              format = " {capacity}% {icon}";
              format-charging = " {capacity}% ";
              format-plugged = " {capacity}% ";
              format-alt = " {time} {icon}";
              #format-icons = ["" "" "" "" ""];
            };
            "battery#bat2" = {
              bat = "BAT2";
              format = " {capacity}% {icon}";
              format-charging = " {capacity}% ";
              format-plugged = " {capacity}% ";
              format-alt = " {time} {icon}";
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
        #tray {
          padding-left: 10px;
          padding-right: 10px;
        }

        #battery {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #battery.warning {
          color: #E6AF2E;
        }

        #battery.critical {
          color: #A3320B;
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
          color: white;
          background-color: #285577;
        }

        #workspaces button.urgent {
          border-color: #c9545d;
          color: #c9545d;
        }

      '';
    };
    home.packages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      wofi 
      sway-run
      grim # screenshots
      slurp # select region 
    ];
}
