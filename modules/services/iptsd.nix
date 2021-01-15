{ config, lib, pkgs, ... } : 

{
  systemd.services = {
    surface-iptsd = {
      enable =
        lib.versionAtLeast config.boot.kernelPackages.kernel.version "5.4";
      description = "Intel Precise Touch & Stylus Daemon";
      documentation = [ "https://github.com/linux-surface/iptsd" ];
      after = [ "dev-ipts-0.device" ];
      wants = [ "dev-ipts-0.device" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig.Type = "simple";
      path = [ pkgs.iptsd ];
      script = ''
        iptsd
      '';
    };
  };

  # # not working with meson flag -Dsystemd=true
  # systemd.packages = [ pkgs.iptsd ];
  # services.udev.packages = [ pkgs.iptsd ];
  services.udev.extraRules = ''
    # iptsd
    KERNEL=="ipts/*", TAG+="systemd";
  '';

  environment.etc."ipts.conf".text = ''
    [Config]
    # BlockOnPalm = false
    # TouchThreshold = 10
    # StabilityThreshold = 0.1
    #
    ## The following values are device specific
    ## and will be loaded from /usr/share/ipts
    ##
    ## Only set them if you need to provide custom
    ## values for new devices that are not yet supported
    #
    # InvertX = false
    # InvertY = false
    # Width = 0
    # Height = 0
  '';
}
