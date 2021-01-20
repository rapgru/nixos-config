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
    WATCH_QUEUE = yes;
    KERNEL_ZSTD = yes;
    IRQ_TIME_ACCOUNTING = yes;
    HAVE_SCHED_AVG_IRQ = yes;
    IKCONFIG = module;
    BUILD_BIN2C = yes;
    UCLAMP_TASK = yes;
    UCLAMP_BUCKETS_COUNT = freeform 5;
    NUMA_BALANCING = yes;
    NUMA_BALANCING_DEFAULT_ENABLED = yes;
    RT_GROUP_SCHED = yes;
    UCLAMP_TASK_GROUP = yes;
    CHECKPOINT_RESTORE = yes;
    BOOT_CONFIG = yes;
    LD_ORPHAN_WARN = yes;
    KALLSYMS_ALL = yes;
    BPF_LSM = yes;
    BPF_JIT_ALWAYS_ON = yes;
    SLAB_FREELIST_RANDOM = yes;
    SLAB_FREELIST_HARDENED = yes;
    SHUFFLE_PAGE_ALLOCATOR = yes;
    DYNAMIC_PHYSICAL_MASK = yes;
    X86_CPU_RESCTRL = yes;
    X86_CPA_STATISTICS = yes;
    AMD_MEM_ENCRYPT = yes;
    X86_INTEL_TSX_MODE_AUTO = yes;
    HZ_300 = yes;
    HZ = freeform 300;
    KEXEC_FILE = yes;
    ARCH_HAS_KEXEC_PURGATORY = yes;
    KEXEC_SIG = yes;
    KEXEC_BZIMAGE_VERIFY_SIG = yes;
    CRASH_DUMP = yes;
    PM_TRACE = yes;
    PM_TRACE_RTC = yes;
    WQ_POWER_EFFICIENT_DEFAULT = yes;
    ENERGY_MODEL = yes;
    ACPI_BUTTON = yes;
    ACPI_FAN = yes;
    ACPI_THERMAL = yes;
    ACPI_DEBUG = yes;
    ACPI_PCI_SLOT = yes;
    ACPI_APEI = yes;
    ACPI_APEI_GHES = yes;
    ACPI_APEI_PCIEAER = yes;
    ACPI_APEI_MEMORY_FAILURE = yes;
    ACPI_DPTF = yes;
    DPTF_PCH_FIVR = module;
    PMIC_OPREGION = yes;
    BYTCRC_PMIC_OPREGION = yes;
    CHTCRC_PMIC_OPREGION = yes;
    CHT_WC_PMIC_OPREGION = yes;
    CPU_FREQ_STAT = yes;
    CPU_FREQ_DEFAULT_GOV_SCHEDUTIL = yes;
    CPU_FREQ_GOV_POWERSAVE = yes;
    CPU_FREQ_GOV_USERSPACE = yes;
    CPU_IDLE_GOV_LADDER = yes;
    EFI_VARS_PSTORE = yes;
    EFI_SOFT_RESERVE = yes;
    EFI_BOOTLOADER_CONTROL = yes;
    UEFI_CPER = yes;
    UEFI_CPER_X86 = yes;
    KVM_MMU_AUDIT = yes;
    HAVE_ARCH_SECCOMP = yes;
    SECCOMP = yes;
    LOCK_EVENT_COUNTS = yes;
    HAVE_STATIC_CALL = yes;
    HAVE_STATIC_CALL_INLINE = yes;
    ARCH_WANT_LD_ORPHAN_WARN = yes;
    # skipped kernel profiling
    MEMORY_HOTPLUG_DEFAULT_ONLINE = yes;
    MEMORY_FAILURE = yes;
    MEM_SOFT_DIRTY = yes;
    # skipped networking
    BT_HCIBTUSB_AUTOSUSPEND = yes;
    BT_HCIBTUSB_MTK = yes;
    PCIEAER = yes;
    PCIE_ECRC = yes;
    PCIE_DPC = yes;
    PCIE_PTM = yes;
    PCIE_EDR = yes;
    PCI_STUB = yes;
    PCI_P2PDMA = yes;
    STANDALONE = yes;
    FW_LOADER_COMPRESS = yes;
    HMEM_REPORTING = yes;
    REGMAP_I2C = yes;
    NVME_CORE = yes;
    BLK_DEV_NVME = yes;
    NVME_MULTIPATH = yes;
    SATA_AHCI = yes;
    SATA_MOBILE_LPM_POLICY = freeform 3;
    KEYBOARD_ATKBD = yes;
    SERIO = yes;
    SERIO_I8042 = yes;
    SERIO_LIBPS2 = yes;
    SERIAL_8250_PCI = yes;
    SERIAL_8250_RT288X = yes;
    SERIAL_8250_LPSS = yes;
    SERIAL_8250_MID = yes;
    SERIAL_DEV_BUS = yes;
    SERIAL_DEV_CTRL_TTYPORT = yes;
    HPET_MMAP = yes;
    HPET_MMAP_DEFAULT = yes;
    RANDOM_TRUST_CPU = yes;
    I2C = yes;
    ACPI_I2C_OPREGION = yes;
    I2C_DESIGNWARE_CORE = yes;
    I2C_DESIGNWARE_SLAVE = yes;
    I2C_DESIGNWARE_PLATFORM = yes;
    I2C_DESIGNWARE_BAYTRAIL = yes;
    PPS = yes;
    PTP_1588_CLOCK = yes;
    PINCTRL_INTEL = yes;
    GPIO_CDEV = yes;
    GPIO_CDEV_V1 = yes;
    THERMAL_NETLINK = yes;
    THERMAL_GOV_FAIR_SHARE = yes;
    THERMAL_GOV_POWER_ALLOCATOR = yes;
    DEVFREQ_THERMAL = yes;
    INTEL_SOC_PMIC = yes;
    INTEL_SOC_PMIC_CHTWC = yes;
    DRM_DP_CEC = yes;
    BACKLIGHT_CLASS_DEVICE = yes;
    SND_HDA_INPUT_BEEP_MODE = freeform 0;
    SND_HDA_POWER_SAVE_DEFAULT = freeform 1;
    SND_HDA_INTEL_HDMI_SILENT_STREAM = yes;
    SND_SOC_SOF_INTEL_SOUNDWIRE_LINK_BASELINE = module;
    HID = yes;
    HID_GENERIC = yes;
    USB_HID = yes;
    USB_COMMON = yes;
    USB_LED_TRIG = yes;
    USB = yes;
    USB_XHCI_HCD = yes;
    USB_XHCI_PCI = yes;
    USB_XHCI_PCI_RENESAS = yes;
    USB_SERIAL = yes;
    USB_SERIAL_CONSOLE = yes;
    LEDS_CLASS = yes;
    LEDS_BRIGHTNESS_HW_CHANGED = yes;
    EDAC = yes;
    EDAC_LEGACY_SYSFS = yes;
    RTC_HCTOSYS = yes;
    RTC_HCTOSYS_DEVICE= freeform "rct0";
    RTC_I2C_AND_SPI = yes;
    RTC_DRV_CMOS = yes;
    DMA_VIRTUAL_CHANNELS = yes;
    DW_DMAC_CORE = yes;
    DW_DMAC_PCI = yes;
    HSU_DMA = yes;
    ASYNC_TX_DMA = yes;
    UDMABUF = yes;
    DMABUF_HEAPS = yes;
    DMABUF_HEAPS_SYSTEM = yes;
    VIRTIO = yes;
    INTEL_TURBO_MAX_3 = yes;
    INTEL_PMC_CORE = yes;
    HWSPINLOCK = yes;
    AMD_IOMMU_V2 = yes;
    INTEL_IOMMU_SVM = yes;
    REMOTEPROC = yes;
    REMOTEPROC_CDEV = yes;
    PM_DEVFREQ_EVENT = yes;
    PWM = yes;
    PWM_SYSFS = yes;
    PWM_CRC = yes;
    IDLE_INJECT = yes;
    RAS = yes;
    RAS_CEC = yes;
    VALIDATE_FS_PARSER = yes;
    EXT4_FS = yes;
    EXT4_USE_FOR_EXT2 = yes;
    JBD2 = yes;
    FS_MBCACHE = yes;
    FS_DAX = yes;
    FS_DAX_PMD = yes;
    EXPORTFS_BLOCK_OPS = yes;
    FS_ENCRYPTION_ALGS = yes;
    FS_ENCRYPTION_INLINE_CRYPT = yes;
    FS_VERITY = yes;
    FANOTIFY_ACCESS_PERMISSIONS = yes;
    AUTOFS4_FS = yes;
    AUTOFS_FS = yes;
    PROC_VMCORE = yes;
    PROC_VMCORE_DEVICE_DUMP = yes;
    PROC_CHILDREN = yes;
    PROC_CPU_RESCTRL = yes;
    TMPFS_INODE64 = yes;
    CONFIGFS_FS = yes;
    EFIVAR_FS = yes;
    PSTORE = yes;
    PSTORE_ZSTD_COMPRESS = yes;
    PSTORE_ZSTD_COMPRESS_DEFAULT = yes;
    PSTORE_COMPRESS_DEFAULT= freeform "zstd";
    PSTORE_RAM = yes;
    NLS_CODEPAGE_437 = yes;
    NLS_ASCII = yes;
    UNICODE = yes;
    KEYS_REQUEST_CACHE = yes;
    PERSISTENT_KEYRINGS = yes;
    ENCRYPTED_KEYS = yes;
    KEY_NOTIFICATIONS = yes;
    SECURITY_DMESG_RESTRICT = yes;
    HARDENED_USERCOPY = yes;
    HARDENED_USERCOPY_FALLBACK = yes;
    FORTIFY_SOURCE = yes;
    SECURITY_SAFESETID = yes;
    SECURITY_LOCKDOWN_LSM_EARLY = yes;
    # skip apparmor/lsm
    DEFAULT_SECURITY_DAC = yes;
    INIT_ON_ALLOC_DEFAULT_ON = yes;
    # skip crypto
    FONTS = yes;
    FONT_TER16x32 = yes;
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
