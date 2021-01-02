# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./modules/greetd.nix
      <home-manager/nixos>
    ];

  nixpkgs.overlays = [ (import ./pkgs) ];
  nixpkgs.config.allowUnfree = true;


  environment.systemPackages = [ pkgs.neofetch pkgs.wayland-utils pkgs.vim pkgs.mkpasswd pkgs.git ];

  services.greetd.enable = true;
  services.greetd.tuigreet.enable = true;
  services.greetd.tuigreet.cmd = "sway-run";
  services.greetd.tuigreet.showTime = true;
  services.greetd.tuigreet.showAsterisks = true;
  services.greetd.tuigreet.customGreeting = "Hello sir! Please log in:";
  
  #programs.sway = {
  #  enable = true;
  #  wrapperFeatures.gtk = true;
  #  extraPackages = with pkgs; [
  #    swaylock
  #    swayidle
  #    wl-clipboard
  #    mako
  #    alacritty
  #    wofi
  #  ];
  #};

  fonts = {
    fonts = with pkgs; [
      fira-code
      fira
      libre-baskerville
    ];
    fontconfig = {
      defaultFonts = {
        serif = [ "Libre Baskerville" ];
        sansSerif = [ "Fira Sans" ];
        monospace = [ "Fira Code" ];
      };
    };
  };

  users.mutableUsers = false;
  users.users.root.hashedPassword = "$6$eaLLB8HjU$fDZ6tylghN2aYHpQ2UUKGpgDVA..buTH4cLaSUzyMVB/kjlPjGl8hdwPd8MZAW3fG8KzWKywCE4JhbqLsQgAe.";
  users.users.rgruber.hashedPassword = "$6$eaLLB8HjU$fDZ6tylghN2aYHpQ2UUKGpgDVA..buTH4cLaSUzyMVB/kjlPjGl8hdwPd8MZAW3fG8KzWKywCE4JhbqLsQgAe.";

  users.users.rgruber = {
    isNormalUser = true;
    home = "/home/rgruber";
    description = "Raphael Gruber";
    extraGroups = [ "wheel" ];
  };


  home-manager.users.rgruber = { pkgs, ... }: {
    wayland.windowManager.sway = {
      enable = true;
      #package = null;
      wrapperFeatures.gtk = true;
      systemdIntegration = false;
      config = {
        output = {
          Virtual-1 = {
            resolution = "1400x1050"; 
          };
        };
        modifier = "Mod4";
        terminal = "${pkgs.alacritty}/bin/alacritty";
        menu = "${pkgs.wofi}/bin/wofi --show drun";
        gaps.inner = 5;
        gaps.smartGaps = true;
        
      };
    }; 
    home.packages = with pkgs; [
      swaylock
      swayidle
      wl-clipboard
      mako
      wofi 
      sway-run
      vivaldi
    ];
    programs.alacritty = {
      enable = true;
    };
  };
  
  # use /etc/profiles
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.device = "/dev/sda";
  boot.initrd.checkJournalingFS = false;
  security.rngd.enable = false;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

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

