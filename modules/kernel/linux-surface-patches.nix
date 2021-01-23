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
  linuxSurfaceConfig = let
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
    (parseFile "=" origConf);

  additionalSurfaceConfig = with lib.kernel; {
    ACPI_BUTTON = yes;
    ACPI_FAN = yes;
    ACPI_THERMAL = yes;
    ACPI_DEBUG = yes;
    ACPI_PCI_SLOT = yes;
    ACPI_APEI = yes;
    ACPI_APEI_GHES = yes;
    ACPI_APEI_PCIEAER = yes;

    BT_HCIBTUSB_AUTOSUSPEND = yes;
    BT_HCIBTUSB_MTK = yes;
    PCIEAER = yes;
    PCIE_ECRC = yes;
    PCIE_DPC = yes;
    PCIE_PTM = yes;
    PCIE_EDR = yes;
    PCI_STUB = yes;
    PCI_P2PDMA = yes;

    KEYBOARD_ATKBD = yes;
    SERIO = yes;
    SERIO_I8042 = yes;
    SERIO_LIBPS2 = yes;

    SERIAL_DEV_BUS = yes;
    SERIAL_DEV_CTRL_TTYPORT = yes;
    
    SERIAL_EARLYCON=yes;
    SERIAL_8250=yes;
    # CONFIG_SERIAL_8250_DEPRECATED_OPTIONS is not set
    SERIAL_8250_PNP=yes;
    # CONFIG_SERIAL_8250_16550A_VARIANTS is not set
    # CONFIG_SERIAL_8250_FINTEK is not set
    SERIAL_8250_CONSOLE=yes;
    SERIAL_8250_DMA=yes;
    SERIAL_8250_PCI=yes;
    # CONFIG_SERIAL_8250_EXAR is not set
    SERIAL_8250_NR_UARTS=freeform "32";
    SERIAL_8250_RUNTIME_UARTS=freeform "4";
    SERIAL_8250_EXTENDED=yes;
    SERIAL_8250_MANY_PORTS=yes;
    SERIAL_8250_SHARE_IRQ=yes;
    # CONFIG_SERIAL_8250_DETECT_IRQ is not set
    SERIAL_8250_RSA=yes;
    SERIAL_8250_DWLIB=yes;
    SERIAL_8250_DW=module;
    SERIAL_8250_RT288X=yes;
    SERIAL_8250_LPSS=yes;
    SERIAL_8250_MID=yes;

    X86_INTEL_LPSS=yes;

    PINCTRL=yes;
    PINMUX=yes;
    PINCONF=yes;
    GENERIC_PINCONF=yes;
    # CONFIG_DEBUG_PINCTRL is not set
    #PINCTRL_AMD=yes;
    #PINCTRL_MCP23S08=yes;
    #PINCTRL_SX150X=yes;
    #PINCTRL_BAYTRAIL=yes;
    #PINCTRL_CHERRYVIEW=yes;
    #PINCTRL_LYNXPOINT=yes;
    #PINCTRL_INTEL=yes;
    #PINCTRL_BROXTON=yes;
    #PINCTRL_CANNONLAKE=yes;
    #PINCTRL_CEDARFORK=yes;
    #PINCTRL_DENVERTON=yes;
    #PINCTRL_EMMITSBURG=yes;
    #PINCTRL_GEMINILAKE=yes;
    #PINCTRL_ICELAKE=yes;

    MFD_INTEL_LPSS=module;
    MFD_INTEL_LPSS_PCI=module;

    INTEL_IDMA64 = module;

    BACKLIGHT_CLASS_DEVICE = yes;
    SND_HDA_INPUT_BEEP_MODE = freeform "0";
    SND_HDA_POWER_SAVE_DEFAULT = freeform "1";
    SND_HDA_INTEL_HDMI_SILENT_STREAM = yes;

    LEDS_CLASS = yes;
    LEDS_BRIGHTNESS_HW_CHANGED = yes;
    INTEL_TURBO_MAX_3 = yes;
    INTEL_PMC_CORE = yes;
    INTEL_IOMMU_SVM = yes;
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
    #assertions = [
    #  { assertion = lib.elem version availablePatchVersions;
    #    message = "No linux-surface kernel patches and configurations for the currently selected kernel version ${version} (propably via boot.kernelPackages) are available";
    #  }
    #]; 

    #boot.kernelPatches = if lib.elem version availablePatchVersions
    #  then [ linuxSurfaceConfig ] ++ [ additionalSurfaceConfig ] ++ linuxSurfacePatches
    #  else [];

    nixpkgs = {
      overlays = [
        (self: super: {
          linux_surface_5_9 = pkgs.linuxPackagesFor (pkgs.linux_5_9.override {
            structuredExtraConfig = (additionalSurfaceConfig // additionalSurfaceConfig);
            # ignoreConfigErrors = true;
            kernelPatches = linuxSurfacePatches;
          });
        })
      ];
    };
  };

  
}
