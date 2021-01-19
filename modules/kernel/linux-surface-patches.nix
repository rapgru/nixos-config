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
     
    #extraConfig = builtins.readFile "${linuxSurface}/configs/surface-${version}.config";
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
      (parseFile "=" origConf);
  };

  additionalSurfaceConfig = {
    name = "additional-surface-config";
    patch = null;
    
    structuredExtraConfig = with lib.kernel; {
      CONFIG_WATCH_QUEUE = yes;
      CONFIG_KERNEL_ZSTD = yes;
      CONFIG_IRQ_TIME_ACCOUNTING = yes;
      CONFIG_HAVE_SCHED_AVG_IRQ = yes;
      CONFIG_IKCONFIG = module;
      CONFIG_BUILD_BIN2C = yes;
      CONFIG_UCLAMP_TASK = yes;
      CONFIG_UCLAMP_BUCKETS_COUNT = 5;
      CONFIG_NUMA_BALANCING = yes;
      CONFIG_NUMA_BALANCING_DEFAULT_ENABLED = yes;
      CONFIG_RT_GROUP_SCHED = yes;
      CONFIG_UCLAMP_TASK_GROUP = yes;
      CONFIG_CHECKPOINT_RESTORE = yes;
      CONFIG_BOOT_CONFIG = yes;
      CONFIG_LD_ORPHAN_WARN = yes;
      CONFIG_KALLSYMS_ALL = yes;
      CONFIG_BPF_LSM = yes;
      CONFIG_BPF_JIT_ALWAYS_ON = yes;
      CONFIG_SLAB_FREELIST_RANDOM = yes;
      CONFIG_SLAB_FREELIST_HARDENED = yes;
      CONFIG_SHUFFLE_PAGE_ALLOCATOR = yes;
      CONFIG_DYNAMIC_PHYSICAL_MASK = yes;
      CONFIG_X86_CPU_RESCTRL = yes;
      CONFIG_X86_CPA_STATISTICS = yes;
      CONFIG_AMD_MEM_ENCRYPT = yes;
      CONFIG_X86_INTEL_TSX_MODE_AUTO = yes;
      CONFIG_HZ_300 = yes;
      CONFIG_HZ = 300;
      CONFIG_KEXEC_FILE = yes;
      CONFIG_ARCH_HAS_KEXEC_PURGATORY = yes;
      CONFIG_KEXEC_SIG = yes;
      CONFIG_KEXEC_BZIMAGE_VERIFY_SIG = yes;
      CONFIG_CRASH_DUMP = yes;
      CONFIG_PM_TRACE = yes;
      CONFIG_PM_TRACE_RTC = yes;
      CONFIG_WQ_POWER_EFFICIENT_DEFAULT = yes;
      CONFIG_ENERGY_MODEL = yes;
      CONFIG_ACPI_BUTTON = yes;
      CONFIG_ACPI_FAN = yes;
      CONFIG_ACPI_THERMAL = yes;
      CONFIG_ACPI_DEBUG = yes;
      CONFIG_ACPI_PCI_SLOT = yes;
      CONFIG_ACPI_APEI = yes;
      CONFIG_ACPI_APEI_GHES = yes;
      CONFIG_ACPI_APEI_PCIEAER = yes;
      CONFIG_ACPI_APEI_MEMORY_FAILURE = yes;
      CONFIG_ACPI_DPTF = yes;
      CONFIG_DPTF_PCH_FIVR = module;
      CONFIG_PMIC_OPREGION = yes;
      CONFIG_BYTCRC_PMIC_OPREGION = yes;
      CONFIG_CHTCRC_PMIC_OPREGION = yes;
      CONFIG_CHT_WC_PMIC_OPREGION = yes;
      CONFIG_CPU_FREQ_STAT = yes;
      CONFIG_CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = yes;
      CONFIG_CPU_FREQ_GOV_POWERSAVE = yes;
      CONFIG_CPU_FREQ_GOV_USERSPACE = yes;
      CONFIG_CPU_IDLE_GOV_LADDER = yes;
      CONFIG_EFI_VARS_PSTORE = yes;
      CONFIG_EFI_SOFT_RESERVE = yes;
      CONFIG_EFI_BOOTLOADER_CONTROL = yes;
      CONFIG_UEFI_CPER = yes;
      CONFIG_UEFI_CPER_X86 = yes;
      CONFIG_KVM_MMU_AUDIT = yes;
      CONFIG_HAVE_ARCH_SECCOMP = yes;
      CONFIG_SECCOMP = yes;
      CONFIG_LOCK_EVENT_COUNTS = yes;
      CONFIG_HAVE_STATIC_CALL = yes;
      CONFIG_HAVE_STATIC_CALL_INLINE = yes;
      CONFIG_ARCH_WANT_LD_ORPHAN_WARN = yes;
      # skipped kernel profiling
      CONFIG_MEMORY_HOTPLUG_DEFAULT_ONLINE = yes;
      CONFIG_MEMORY_FAILURE = yes;
      CONFIG_MEM_SOFT_DIRTY = yes;
      # skipped networking
      CONFIG_BT_HCIBTUSB_AUTOSUSPEND = yes;
      CONFIG_BT_HCIBTUSB_MTK = yes;
      CONFIG_PCIEAER = yes;
      CONFIG_PCIE_ECRC = yes;
      CONFIG_PCIE_DPC = yes;
      CONFIG_PCIE_PTM = yes;
      CONFIG_PCIE_EDR = yes;
      CONFIG_PCI_STUB = yes;
      CONFIG_PCI_P2PDMA = yes;
      CONFIG_STANDALONE = yes;
      CONFIG_FW_LOADER_COMPRESS = yes;
      CONFIG_HMEM_REPORTING = yes;
      CONFIG_REGMAP_I2C = yes;
      CONFIG_NVME_CORE = yes;
      CONFIG_BLK_DEV_NVME = yes;
      CONFIG_NVME_MULTIPATH = yes;
      CONFIG_SATA_AHCI = yes;
      CONFIG_SATA_MOBILE_LPM_POLICY = 3;
      CONFIG_KEYBOARD_ATKBD = yes;
      CONFIG_SERIO = yes;
      CONFIG_SERIO_I8042 = yes;
      CONFIG_SERIO_LIBPS2 = yes;
      CONFIG_SERIAL_8250_PCI = yes;
      CONFIG_SERIAL_8250_RT288X = yes;
      CONFIG_SERIAL_8250_LPSS = yes;
      CONFIG_SERIAL_8250_MID = yes;
      CONFIG_SERIAL_DEV_BUS = yes;
      CONFIG_SERIAL_DEV_CTRL_TTYPORT = yes;
      CONFIG_HPET_MMAP = yes;
      CONFIG_HPET_MMAP_DEFAULT = yes;
      CONFIG_RANDOM_TRUST_CPU = yes;
      CONFIG_I2C = yes;
      CONFIG_ACPI_I2C_OPREGION = yes;
      CONFIG_I2C_DESIGNWARE_CORE = yes;
      CONFIG_I2C_DESIGNWARE_SLAVE = yes;
      CONFIG_I2C_DESIGNWARE_PLATFORM = yes;
      CONFIG_I2C_DESIGNWARE_BAYTRAIL = yes;
      CONFIG_PPS = yes;
      CONFIG_PTP_1588_CLOCK = yes;
      CONFIG_PINCTRL_INTEL = yes;
      CONFIG_GPIO_CDEV = yes;
      CONFIG_GPIO_CDEV_V1 = yes;
      CONFIG_THERMAL_NETLINK = yes;
      CONFIG_THERMAL_GOV_FAIR_SHARE = yes;
      CONFIG_THERMAL_GOV_POWER_ALLOCATOR = yes;
      CONFIG_DEVFREQ_THERMAL = yes;
      CONFIG_INTEL_SOC_PMIC = yes;
      CONFIG_INTEL_SOC_PMIC_CHTWC = yes;
      CONFIG_DRM_DP_CEC = yes;
      CONFIG_BACKLIGHT_CLASS_DEVICE = yes;
      CONFIG_SND_HDA_INPUT_BEEP_MODE = 0;
      CONFIG_SND_HDA_POWER_SAVE_DEFAULT = 1;
      CONFIG_SND_HDA_INTEL_HDMI_SILENT_STREAM
      CONFIG_SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE = module;
      CONFIG_HID = yes;
      CONFIG_HID_GENERIC = yes;
      CONFIG_USB_HID = yes;
      CONFIG_USB_COMMON = yes;
      CONFIG_USB_LED_TRIG = yes;
      CONFIG_USB = yes;
      CONFIG_USB_XHCI_HCD = yes;
      CONFIG_USB_XHCI_PCI = yes;
      CONFIG_USB_XHCI_PCI_RENESAS = yes;
      CONFIG_USB_SERIAL = yes;
      CONFIG_USB_SERIAL_CONSOLE = yes;
      CONFIG_LEDS_CLASS = yes;
      CONFIG_LEDS_BRIGHTNESS_HW_CHANGED = yes;
      CONFIG_EDAC = yes;
      CONFIG_EDAC_LEGACY_SYSFS = yes;
      CONFIG_RTC_HCTOSYS = yes;
      CONFIG_RTC_HCTOSYS_DEVICE="rct0";
      CONFIG_RTC_I2C_AND_SPI = yes;
      CONFIG_RTC_DRV_CMOS = yes;
      CONFIG_DMA_VIRTUAL_CHANNELS = yes;
      CONFIG_DW_DMAC_CORE = yes;
      CONFIG_DW_DMAC_PCI = yes;
      CONFIG_HSU_DMA = yes;
      CONFIG_ASYNC_TX_DMA = yes;
      CONFIG_UDMABUF = yes;
      CONFIG_DMABUF_HEAPS = yes;
      CONFIG_DMABUF_HEAPS_SYSTEM = yes;
      CONFIG_VIRTIO = yes;
      CONFIG_INTEL_TURBO_MAX_3 = yes;
      CONFIG_INTEL_PMC_CORE = yes;
      CONFIG_HWSPINLOCK = yes;
      CONFIG_AMD_IOMMU_V2 = yes;
      CONFIG_INTEL_IOMMU_SVM = yes;
      CONFIG_REMOTEPROC = yes;
      CONFIG_REMOTEPROC_CDEV = yes;
      CONFIG_PM_DEVFREQ_EVENT = yes;
      CONFIG_PWM = yes;
      CONFIG_PWM_SYSFS = yes;
      CONFIG_PWM_CRC = yes;
      CONFIG_IDLE_INJECT = yes;
      CONFIG_RAS = yes;
      CONFIG_RAS_CEC = yes;
      CONFIG_VALIDATE_FS_PARSER = yes;
      CONFIG_EXT4_FS = yes;
      CONFIG_EXT4_USE_FOR_EXT2 = yes;
      CONFIG_JBD2 = yes;
      CONFIG_FS_MBCACHE = yes;
      CONFIG_FS_DAX = yes;
      CONFIG_FS_DAX_PMD = yes;
      CONFIG_EXPORTFS_BLOCK_OPS = yes;
      CONFIG_FS_ENCRYPTION_ALGS = yes;
      CONFIG_FS_ENCRYPTION_INLINE_CRYPT = yes;
      CONFIG_FS_VERITY = yes;
      CONFIG_FANOTIFY_ACCESS_PERMISSIONS = yes;
      CONFIG_AUTOFS4_FS = yes;
      CONFIG_AUTOFS_FS = yes;
      CONFIG_PROC_VMCORE = yes;
      CONFIG_PROC_VMCORE_DEVICE_DUMP = yes;
      CONFIG_PROC_CHILDREN = yes;
      CONFIG_PROC_CPU_RESCTRL = yes;
      CONFIG_TMPFS_INODE64 = yes;
      CONFIG_CONFIGFS_FS = yes;
      CONFIG_EFIVAR_FS = yes;
      CONFIG_PSTORE = yes;
      CONFIG_PSTORE_ZSTD_COMPRESS = yes;
      CONFIG_PSTORE_ZSTD_COMPRESS_DEFAULT = yes;
      CONFIG_PSTORE_COMPRESS_DEFAULT="zstd";
      CONFIG_PSTORE_RAM = yes;
      CONFIG_NLS_CODEPAGE_437 = yes;
      CONFIG_NLS_ASCII = yes;
      CONFIG_UNICODE = yes;
      CONFIG_KEYS_REQUEST_CACHE = yes;
      CONFIG_PERSISTENT_KEYRINGS = yes;
      CONFIG_ENCRYPTED_KEYS = yes;
      CONFIG_KEY_NOTIFICATIONS = yes;
      CONFIG_SECURITY_DMESG_RESTRICT = yes;
      CONFIG_HARDENED_USERCOPY = yes;
      CONFIG_HARDENED_USERCOPY_FALLBACK = yes;
      CONFIG_FORTIFY_SOURCE = yes;
      CONFIG_SECURITY_SAFESETID = yes;
      CONFIG_SECURITY_LOCKDOWN_LSM_EARLY = yes;
      # skip apparmor/lsm
      CONFIG_DEFAULT_SECURITY_DAC = yes;
      CONFIG_INIT_ON_ALLOC_DEFAULT_ON = yes;
      # skip crypto
      CONFIG_FONTS = yes;
      CONFIG_FONT_TER16x32 = yes;
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
      then [ linuxSurfaceConfig ] ++ [ additionalSurfaceConfig ] ++ linuxSurfacePatches
      else [];
  };
}
