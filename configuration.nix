# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # home manager
      <home-manager/nixos>

      # general modules
      ./modules/services/greetd.nix
      ./modules/kernel/linux-surface-patches.nix
      ./modules/services/iptsd.nix

      # configuration modules
      ./config/hardware-configuration.nix
      ./config/login.nix
      ./config/users.nix
      ./config/surface-specific.nix
      ./config/virtualization.nix
    ];

  nixpkgs.overlays = [ (import ./pkgs) ];
  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.pulseaudio = true;

  environment.systemPackages = with pkgs; [
    neofetch
    wayland-utils
    vim
    mkpasswd
    git
    nix-index
    file
    brillo
    surface-control
  ];
  
  fonts = {
    fonts = with pkgs; [
      fira-code
      fira
      libre-baskerville
      font-awesome
      ubuntu_font_family
      noto-fonts-emoji
      noto-fonts-cjk
      noto-fonts
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Libre Baskerville" ];
        sansSerif = [ "Fira Sans" "Font Awesome 5 Free" ];
        monospace = [ "Fira Code" "Font Awesome 5 Free" ];
      };
    };
  };

  home-manager.users.rgruber = { pkgs, ... }: {
    imports = [
      ./config/rgruber/sway.nix
      ./config/rgruber/default.nix
    ];
  };
  
  # use /etc/profiles
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  programs.dconf.enable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # LUKS encryption
  boot.initrd.luks.devices.nixos = {
    name = "nixos";
    device = "/dev/disk/by-uuid/432d83cc-b474-4dd1-8b03-67d9e6425465";
    preLVM = true;
  };

  boot.plymouth.enable = true;

  networking.hostName = "nixos-surface"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";
  time.hardwareClockInLocalTime = true;

  hardware.pulseaudio = {
    enable = true;
    support32Bit = true;
    package = pkgs.pulseaudioFull;
    daemon.config = {
      default-sample-rate = 48000;
      default-fragments = 8;
      default-fragment-size-msec = 10;
    };
  };
  sound.enable = true;

  services.pipewire.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-wlr ];
  xdg.portal.gtkUsePortal = true;
 
  security.pam.services.swaylock = {
    text = ''
      auth include login
    '';
  };
  
  services.udisks2.enable = true;

  services.printing = {
    enable = true;
    drivers = with pkgs; [ samsungUnifiedLinuxDriver hplip gutenprint canon-cups-ufr2 ];
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
  };
  
  services.logind = {
    lidSwitch = "suspend";
    lidSwitchDocked = "hybrid-sleep";
    extraConfig = ''
      HandlePowerKey = "hybrid-sleep";
    '';
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.wlp1s0.useDHCP = true;
  # networking.interfaces.wlp1s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    # font = "Lat2-Terminus16";
    font = "${pkgs.terminus_font}/share/consolefonts/ter-v32n.psf.gz";
    keyMap = "us";
  };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  # users.users.jane = {
  #   isNormalUser = true;
  #   extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
  # };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #   wget vim
  #   firefox
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

