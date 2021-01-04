{ config, pkgs, lib, ... }:

{
  imports = [
    ./linux-surface.nix
    # testing
    # ../nixos-hardware/microsoft/surface
  ];

  hardware = {
    acpilight.enable = true;
    # surface wifi doesn't work alongside bluetooth
    # depends on model, maybe even varies device-to-device
    bluetooth.enable = false;
  };

  boot.kernelPackages = pkgs.linuxPackages_5_9;

  networking = {
    # wireless.enable = true;
    # wireless.networks = {
    #  "Dukommsthiernichtrein" = {
    #     pskRaw = "debbeaa17eebab21e1241703253ec6b371236724ad3c247ce5276cc5b515a9a2";
    #  };
    #};
    networkmanager.enable = true;
    networkmanager.wifi = {
      powersave = false;
      scanRandMacAddress = false;
    };
  };
  
  hardware = {
    opengl = {
      enable = true;
    };
    opengl.driSupport = true;
    opengl.driSupport32Bit = true;
  };

  environment.systemPackages = [ pkgs.acpilight ];

  # home-manager.users.lh = {
  #  profiles.user.xorg-base.enable = true;
  #
  #  home = {
  #  packages = with pkgs; [ onboard ];
  #    sessionVariables.MOZ_USE_XINPUT2 = 1;
  #  };
  #  xsession.pointerCursor.size = 64;
#
  #  services.polybar.config."module/wlan".interface = "wlp1s0";
  #};
}
