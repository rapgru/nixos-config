{ config, pkgs, lib, ... }:

{
  hardware = {
    acpilight.enable = true;
    # surface wifi doesn't work alongside bluetooth
    # depends on model, maybe even varies device-to-device
    bluetooth.enable = true;
  };

  boot.kernelPackages = pkgs.linuxPackages_5_9;

  networking = {
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
}
