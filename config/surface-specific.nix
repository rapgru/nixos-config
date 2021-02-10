{ config, pkgs, lib, ... }:

{
  
  #imports = [ 
  #  "${builtins.fetchGit { url = "https://github.com/NixOS/nixos-hardware.git"; rev = "a0d8383c422f85f37fccee5af74b1cb4b52287d9"; }}/microsoft/surface"
  #];
 
  hardware = {
    acpilight.enable = true;
    # surface wifi doesn't work alongside bluetooth
    # depends on model, maybe even varies device-to-device
    bluetooth.enable = true;
  };

  boot.kernelPackages = pkgs.linux_surface_5_9;

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

  environment.systemPackages = [ pkgs.acpilight pkgs.surface-control ];

  security.sudo.extraRules = [
    { groups = ["surfaceuser"]; commands = [{command="${pkgs.surface-control}/bin/surface"; options = [ "SETENV" "NOPASSWD"];}];  }
  ];

  users.groups = {
    surfaceuser = {};
  };
}
