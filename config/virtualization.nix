{ lib, pkgs, ... }:

{
  virtualisation.docker.enable = true;
  environment.systemPackages = [ pkgs.docker-compose ];
  virtualisation.libvirtd.enable = true;
  # virtualisation.virtualbox.host.enable = true;
}
