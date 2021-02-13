{ config, lib, pkgs, ... } :
with lib;
let
  gcfg = config.services.greetd;

  configText = ''
  [terminal]
  vt = 1
  
  [default_session]
  ${optionalString gcfg.tuigreet.enable
    ''
      command="${pkgs.tuigreet}/bin/tuigreet --cmd ${gcfg.tuigreet.cmd} ${optionalString gcfg.tuigreet.showTime "-t"} ${optionalString gcfg.tuigreet.showIssue "-i"} ${optionalString (gcfg.tuigreet.customGreeting != "") ''-g \"${gcfg.tuigreet.customGreeting}\"''} ${optionalString gcfg.tuigreet.showAsterisks "--asterisks"}"
    ''}

  ${optionalString gcfg.gtkgreet.enable
    ''
      command="${pkgs.sway}/bin/sway --config /etc/greetd/sway-config"
    ''}
  user = "greeter"
  '';

in

{
  options = {
    services.greetd = {
      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Wether to enable greetd as the display manager";
      };
      tuigreet = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Wether to use tuigreet as greetd greeter";
        };
        cmd = mkOption {
          type = types.str;
          description = "Command to execute on login";
        };
        showIssue = mkOption {
          type = types.bool;
          default = false;
          description = "Wether to show the issue in tuigreet";
        };
        showAsterisks = mkOption {
          type = types.bool;
          default = false;
          description = "Wether to show asterisks in the password field";
        };
        showTime = mkOption {
          type = types.bool;
          default = false;
          description = "Wether to show the current time in tuigreet";
        };
        customGreeting = mkOption {
          type = types.str;
          default = "";
          description = "Custom greeting string";
        };
      };
      gtkgreet = {
        enable = mkOption {
          type = types.bool;
          default = false;
          description = "Wether to use gtkgreet as greetd greeter";
        };
      };
      environments = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of commands that can be started from the greeter";
      };
    };
  };

  config = mkIf gcfg.enable {
  assertions = [
    { assertion = !((gcfg.tuigreet.customGreeting != "") && gcfg.tuigreet.showIssue);
      message = "tuigreet cannot show a customGreeting and issue at the same time!";
    }
  ];


  # create config file in /etc
  environment = {
    etc."greetd/config.toml".text = configText;
    etc."greetd/config.toml".user = "greeter";
    etc."greetd/config.toml".group = "greeter";

    etc."greetd/sway-config" = mkIf gcfg.gtkgreet.enable {
      text = ''
        # `-l` activates layer-shell mode. Notice that `swaymsg exit` will run after gtkgreet.
        exec "${pkgs.gtkgreet}/bin/gtkgreet -l; swaymsg exit"

        bindsym Mod4+shift+e exec swaynag \
          -t warning \
          -m 'What do you want to do?' \
          -b 'Poweroff' 'systemctl poweroff' \
          -b 'Reboot' 'systemctl reboot'
      '';
      user = "greeter";
      group = "greeter";
    };
  
    etc."greetd/environments" = mkIf gcfg.enable {
      user = "greeter";
      group = "greeter";
      
      text = ''
        ${lib.concatStringsSep "\n" gcfg.environments}
      ''; 
    };
  }; 

  # unit display-manager is started during graphical.target
  systemd.defaultUnit = "graphical.target";

  # create systemd service
  systemd.services.greetd = {
    description = ''
      Greeter daemon
    '';
    # after = [ "systemd-user-sessions.service" "plymouth-quit-wait.service" "getty@tty1.service" "user.slice" ];
    after = [ "rc-local.service" "networking.service" "systemd-machined.service" "systemd-user-sessions.service" "getty@tty1.service" "systemd-logind.service" "acpid.service" ];
    conflicts = [ "getty@tty1.service" ];
    restartIfChanged = false;
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.greetd}/bin/greetd";
      IgnoreSIGPIPE = "no";
      SendSIGHUP = "yes";
      TimeoutStopSec = "30s";
      KeyringMode = "shared";
      Restart = "always";
      RestartSec = "1";
      StartLimitBurst = "5";
      StartLimitInterval = "30";
    }; 
    aliases = [ "display-manager.service" ];
    enable = true;
  };

  systemd.services.greetd.environment.XDG_DATA_DIRS= "${config.services.xserver.displayManager.sessionData.desktops}/share/";


  # create greetd user
  users.users.greeter = {
    isNormalUser = false;
    description = "greetd user";
    group = "greeter";
    extraGroups = [ "video" ];
  };
  # create greeter group
  users.groups.greeter.name = "greeter";
  };
}
