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
