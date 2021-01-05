{ config, lib, pkgs, ... }:

let

  # linux-surface github repo
  linuxSurface = pkgs.fetchFromGitHub {
    inherit (lib.importJSON ../linux-surface.json)
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
     
    structuredExtraConfig = let
        origConf = builtins.readFile
          "${linuxSurface}/configs/surface-${version}.config";

        flatten = x:
          if builtins.isList x then
            builtins.concatMap (y: flatten y) x
          else
            [ x ];

        kernelValues = with lib.kernel; {
          y = yes;
          n = no;
          m = module;
        };

        tokenize = sep: str:
          let x = flatten (builtins.split sep str);
          in if builtins.length x < 2 then
            null
          else {
            name = builtins.head x;
            value = kernelValues."${builtins.head (builtins.tail x)}";
          };

        parseFile = with builtins;
          sep: str:
          (listToAttrs (map (tokenize sep) (filter (str: str != "")
            (flatten (map (builtins.split "^CONFIG_") (flatten
              (filter isList (map (match "^(CONFIG_.*[mny]).*")
                (flatten (split "\n" str))))))))));
      in with lib.kernel;
      (parseFile "=" origConf) // {
        # https://github.com/NixOS/nixpkgs/issues/88073
        SERIAL_DEV_BUS = yes;
        SERIAL_DEV_CTRL_TTYPORT = yes;

        # https://github.com/linux-surface/linux-surface/issues/61
        PINCTRL_INTEL = yes;
        PINCTRL_SUNRISEPOINT = yes;
      };
  };

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
