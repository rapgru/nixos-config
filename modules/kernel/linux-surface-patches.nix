{ config, lib, pkgs, ... }:

let

  # linux-surface github repo
  linuxSurface = pkgs.fetchFromGitHub {
    inherit (lib.importJSON ./linux-surface.json)
      owner repo rev sha256;

    # owner = "linux-surface";
    # repo = "linux-surface";
    # rev = "debian-5.10.2-1";
    # sha256 = "03f2jjcmwmhnxjsnf931j98pr6i9rdh2hvf530lb3cvr3hhj89li";
  };
  
  # currently selected kernel version => for folder selection in linux-surface repo
  version = lib.versions.majorMinor "${config.boot.kernelPackages.kernel.version}";

  availablePatchVersions = lib.mapAttrsToList (n: v: n) (builtins.readDir "${linuxSurface}/patches");

  # Linux Surface Extra Configuration Patch
  linuxSurfaceConfig = {
    name = "linux-surface-config";
    patch = null;
     
    extraConfig = builtins.readFile "${linuxSurface}/configs/surface-${version}.config";
  };

  additionalSurfaceConfig = {
    name = "additional-surface-config";
    patch = null;
    
    extraConfig = ''
      
    '';
  }

  # get patches from linux-surface patches directory
  # convert to attrset format nix expects
  linuxSurfacePatches = let
        mapDir = f: p:
          builtins.attrValues
          (builtins.mapAttrs (k: _: f p k) (builtins.readDir p));
        patch = dir: file: {
          name = file;
          patch = dir + "/${file}";
        };
      in mapDir patch "${linuxSurface}/patches/${version}";
in  
{
  config = { 
    assertions = [
      { assertion = lib.elem version availablePatchVersions;
        message = "No linux-surface kernel patches and configurations for the currently selected kernel version ${version} (propably via boot.kernelPackages) are available";
      }
    ]; 

    boot.kernelPatches = if lib.elem version availablePatchVersions
      then [ linuxSurfaceConfig ] ++ linuxSurfacePatches
      else [];
  };
}
