{ lib, pkgs, ... }:

let colors = (import ./colors.nix);
in
{

    home.file = {
      "wall.jpg" = {
        source = ./nord-mountain.jpg;
      };
    };

    wayland.windowManager.sway = {
      enable = true;
      #package = null;
      wrapperFeatures.gtk = true;
      wrapperFeatures.base = true;
      systemdIntegration = false;
      config = {
        output = {
          # Surface Monitor
          eDP-1 = {
            resolution = "3000x2000"; 
            scale = "2";
            position = "530,1440";
          };
          # Samsung Full HD Monitor
          DP-1 = {
            resolution = "1920x1080";
            scale = "1";
            position = "530,360";
          };
          # Dell
          DP-3 = {
            resolution = "2560x1440";
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
          "1118:33:IPTS_Touch" = {
            map_to_output = "eDP-1";
          };
          "1118:33:IPTS_Stylus" = {
            map_to_output = "eDP-1";
          };
        };
        keybindings = let
          modifier-win = "Mod4";
          modifier-alt = "Mod1";
        in
          lib.mkOptionDefault {
            "XF86AudioRaiseVolume" = "exec pulsemixer --change-volume +5 && bash ${pkgs.mywob}/bin/mywob $(echo \"($(pulsemixer --get-volume | awk '{print $1}')/150.0)*100\" | bc -l | sed 's/\\.[0-9]*//g')";
            "XF86AudioLowerVolume" = "exec pulsemixer --change-volume -5 && bash ${pkgs.mywob}/bin/mywob $(echo \"($(pulsemixer --get-volume | awk '{print $1}')/150.0)*100\" | bc -l | sed 's/\\.[0-9]*//g')";
            "XF86AudioMute" = "exec pulsemixer --toggle-mute";
            "XF86AudioPlay" = "exec playerctl play-pause";
            "XF86MonBrightnessUp" = "exec brillo -A 5 && bash ${pkgs.mywob}/bin/mywob $(brillo | sed 's/\\.[0-9]*//g')";
            "XF86MonBrightnessDown" = "exec brillo -U 5 && bash ${pkgs.mywob}/bin/mywob $(brillo | sed 's/\\.[0-9]*//g')";
            "${modifier-win}+shift+g" = ''exec grim -g "$(slurp)" - | wl-copy --type image/png'';
            "${modifier-alt}+tab" = "workspace back_and_forth";
            "${modifier-win}+o" = "exec swaylock --screenshots --effect-blur 5x7 --effect-vignette 0.5:0.5 --fade-in 0.2 --clock --indicator";
          };
        modifier = "Mod4";
        assigns = {
          "1:www" = [{ class = "^Vivaldi-stable$"; } { app_id = "firefox"; }];
          "8:mail" = [{ app_id = "thunderbird"; }];
          "9:comm" = [{ class = "discord"; } { class = "Element"; } { class = "Microsoft Teams - Preview";}];
        };
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.wofi}/bin/wofi --show drun";
        gaps.inner = 5;
        gaps.smartGaps = true;
        startup = [
          { command = "systemctl --user import-environment"; }
          { command = "systemctl --user start graphical-session.target"; }
          { command = "swaybg -i /home/rgruber/wall.jpg -m fill"; }
          { command = "udiskie --tray --appindicator"; }
          { command = "firefox"; }
          { command = "thunderbird"; }
          { command = ''"sleep 5; Discord"''; }
          # do not start teams, as this writes mimeapps.list with awk and crashes home-manager-rgruber.service
          # { command = "teams"; }
          { command = "element-desktop"; }
          { command = "playerctld"; }
          { command = "${pkgs.libinput-gestures}/bin/libinput-gestures"; }
          { 
            command = ''
              swayidle -w \
    timeout 300  'swaylock --screenshots --effect-blur 5x7 --effect-vignette 0.5:0.5 --fade-in 0.2 --clock --indicator' \
    timeout 600  'swaymsg "output * dpms off"' \
    resume       'swaymsg "output * dpms on"' \
    before-sleep 'swaylock --screenshots --effect-blur 5x7 --effect-vignette 0.5:0.5 --fade-in 0.2 --clock --indicator' \
    lock         'swaylock --screenshots --effect-blur 5x7 --effect-vignette 0.5:0.5 --fade-in 0.2 --clock --indicator'
            '';
          }
        ];
        bars = [
          { command = "${pkgs.waybar}/bin/waybar"; }
        ];
        colors = {
          focused = {
            background = colors.nord0;
            border = colors.nord1;
            childBorder = colors.nord13;
            indicator = colors.nord8;
            text = colors.nord6;
          };
          unfocused = {
            background = colors.nord0;
            border = colors.nord1;
            childBorder = colors.nord1;
            indicator = colors.nord3;
            text = colors.nord6;
          };
          focusedInactive = {
            background = colors.nord0;
            border = colors.nord1;
            childBorder = colors.nord1;
            indicator = colors.nord3;
            text = colors.nord6;
          };
          urgent = {
            background = colors.nord12;
            border = colors.nord12;
            childBorder = colors.nord12;
            indicator = colors.nord3;
            text = colors.nord6;
          };
        };
      };
      extraConfig = ''
        workspace "1:www" output DP-3 DP-1
        workspace 2 output DP-3 DP-1
        workspace 3 output DP-3 DP-1
        workspace 4 output DP-3 DP-1
        workspace "8:mail" output eDP-1
        workspace "9:comm" output eDP-1
        for_window [app_id="thunderbird"] floating enable
        for_window [class="discord"] layout stacking
        default_border none
      '';
    }; 
    programs.mako = {
      enable = true;
      backgroundColor = colors.nord2;
      borderSize = 0;
      textColor = colors.nord6;
    };
    home.file.".config/libinput-gestures.conf".text = ''
      gesture swipe right 3 swaymsg workspace next
      gesture swipe left 3 swaymsg workspace prev
    '';
    home.file.".config/swaylock/config".text = ''
      # Turn the screen into the given color instead of white
      color=2e3440ff
      
      # Enable debugging output
      # debug
      
      # When an empty password is provided by the user, do not validate it
      ignore-empty-password
      
      # Show the number of failed authentication attempts on the indicator
      # show-failed-attempts
      
      # Detach from the controlling terminal after locking
      # Note: this is the default behavior of i3lock
      # daemonize
      
      # Display the given image
      # image [[<output>]:]<path>
      
      # Display the current xkb layout while typing
      # show-keyboard-layout
      
      # Force hiding the current xkb layout while typing, even if more than one layout
      # is configured or the show-keyboard-layout option is set
      # hide-keyboard-layout
      
      # Disable the Caps Lock Text
      # disable-caps-lock-text
      
      # Show the current Caps Lock state also on the indicator
      # indicator-caps-lock
      
      # Image scaling mode: 'stretch', 'fill', 'fit', 'center', 'tile' & 'solid\color'
      # scaling
      
      # Same as scaling=tile
      # tiling
      
      # Disable the unlock indicator
      # no-unlock-indicator
      
      # Sets the color of backspace highlight segments
      bs-hl-color=b48eadff
      
      # Sets the color of backspace highlight segments when Caps Lock is active
      caps-lock-bs-hl-color=d08770ff
      
      # Sets the color of the key press highlight segments when Caps Lock is active
      caps-lock-key-hl-color=ebcb8bff
      
      # Sets the font of the text
      font=Fira Sans Light
      
      # FUTURE RELEASE
      # Sets a fixed font size for the indicator text
      # font-size=<size>
      
      # FUTURE RELEASE
      # Sets the indicator to show even if idle
      # indicator-idle-visible
      
      # Sets the indicator radius (default: 50)
      indicator-radius=100

      # Sets the indicator thickness (default: 10)
      indicator-thickness=10
      
      # FUTURE RELEASE
      # Sets the horizontal position of the indicator
      # indicator-x-position
      
      # FUTURE RELEASE
      # Sets the vertical position of the indicator
      # indicator-y-position
      
      # Sets the color of the inside of the indicator
      inside-color=2e3440ff
      
      # Sets the color of the inside of the indicator when cleared
      inside-clear-color=81a1c1ff
      
      # Sets the color of the inside of the indicator when Caps Lock is active
      # inside-caps-lock-color=<rrggbb[aa]>
      
      # Sets the color of the inside of the indicator when verifying
      inside-ver-color=5e81acff
      
      # Sets the color of the inside of the indicator when invalid
      inside-wrong-color=bf616aff
      
      # Sets the color of key press highlight segments
      key-hl-color=a3be8cff
      
      # Sets the background color of the box containing the layout text
      layout-bg-color=2e3440ff
      
      # Sets the color of the border of the box containing the layout text
      # layout-border-color=<rrggbb[aa]>
      
      # Sets the color of the layout text
      # layout-text-color=<rrggbb[aa]>
      
      # Sets the color of the line between the inside and ring
      # line-color=<rrggbb[aa]>
      
      # Sets the color of the line between the inside and ring when cleared
      # line-clear-color=<rrggbb[aa]>
      
      # Sets the color of the line between the inside and ring when Caps Lock is active
      # line-caps-lock-color=<rrggbb[aa]>
      
      # Sets the color of the line between the inside and ring when verifying
      # line-ver-color=<rrggbb[aa]>
      
      # Sets the color of the line between the inside and ring when invalid
      # line-wrong-color=<rrggbb[aa]>
      
      # Use the inside color for the line between the inside and ring
      # line-uses-inside
      
      # Use the ring color for the line between the inside and ring
      line-uses-ring
      
      # Sets the color of the outside of the indicator when typing or idle
      ring-color=3b4252ff
      
      # Sets the color of the outside of the indicator when cleared
      ring-clear-color=88c0d0ff
      
      # Sets the color of the ring of the indicator when Caps Lock is active
      # ring-caps-lock-color=<rrggbb[aa]>
      
      # Sets the color of the outside of the indicator when verifying
      ring-ver-color=81a1c1ff
      
      # Sets the color of the outside of the indicator when invalid
      ring-wrong-color=d08770ff
      
      # Sets the color of the lines that separate highlight segments
      separator-color=3b4252ff
      
      # Sets the color of the text
      text-color=eceff4ff
      
      # Sets the color of the text when cleared
      text-clear-color=3b4252ff
      
      # Sets the color of the text when Caps Lock is active
      # text-caps-lock-color=<rrggbb[aa]>
      
      # Sets the color of the text when verifying
      text-ver-color=3b4252ff
      
      # Sets the color of the text when invalid
      text-wrong-color=3b4252ff
    '';
    home.file.".config/wofi/style.css".text = ''
      
      window {
      margin: 0px;
      /* border: 1px solid #bd93f9; */
      }
      
      #input {
      margin: 5px;
      border: none;
      }
      
      #inner-box {
      margin: 5px;
      border: none;
      }
      
      #outer-box {
      margin: 5px;
      border: none;
      }
      
      #scroll {
      margin: 0px;
      border: none;
      }
      
      #text {
      margin: 5px;
      border: none;
      } 
      
      #entry:selected {
      }        
    '';
    gtk = {
      enable = true;
      font = { 
        name = "Fira Sans 10";
      }; 
      iconTheme = {
        package = pkgs.gnome3.adwaita-icon-theme;
        name = "Adwaita";
      };
      theme = {
        package = pkgs.nordic;
        name = "Nordic";
      };
    };
    qt = {
      enable = true;
      platformTheme = "gtk";
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
              states = {
                warning = 85;
                critical = 95;
              };
              interval = 1;
              tooltip = false;
            };
            battery = {
              bat = "BAT2";
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
              bat = "BAT1";
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
          }

          to {
            background-color: ${colors.nord13};
          }
        }

        @keyframes blink-critical {
          70% {
          }

          to {
            background-color: ${colors.nord11};
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
          background: ${colors.nord0};
          font-family: sans-serif;
          font-size: 13px;
          color: ${colors.nord6};
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
          color: ${colors.nord13};
        }

        #battery.critical, battery.bat2.critical {
          color: ${colors.nord11};
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
          color: ${colors.nord13};
        }

        #cpu.critical {
          color: ${colors.nord11};
        }

        #memory {
          animation-timing-function: linear;
          animation-iteration-count: infinite;
          animation-direction: alternate;
        }

        #memory.warning {
          color: ${colors.nord13};
        }

        #memory.critical {
          color: ${colors.nord11};
          animation-name: blink-critical;
          animation-duration: 2s;
        }

        #network.disconnected {
          color: ${colors.nord13};
        }

        #workspaces button {
          /* border-top: 2px solid transparent; */
          /* To compensate for the top border and still have vertical centering */
          /* padding-bottom: 2px; */
          padding-left: 10px;
          padding-right: 10px;
          color: ${colors.nord4};
          background-color: ${colors.nord2};
        }

        #workspaces button.focused {
          /* border-color: #4c7899; */
          color: ${colors.nord6};
          background-color: ${colors.nord9};
        }

        #workspaces button.urgent {
          /* border-color: #c9545d; */
          /* color: #c9545d; */
          background-color: ${colors.nord12};
        }

      '';
    };
    home.packages = with pkgs; [
      swaylock-effects
      swayidle
      swaybg
      wl-clipboard
      wofi 
      sway-run
      grim # screenshots
      slurp # select region 
      libsecret # for nextcloud client
      playerctl
      mywob
      wob
    ];
}
