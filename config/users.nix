{ lib, pkgs, ... } :

{
  programs.fish.enable = true;

  users.mutableUsers = false;
  users.users.root.hashedPassword = "$6$eaLLB8HjU$fDZ6tylghN2aYHpQ2UUKGpgDVA..buTH4cLaSUzyMVB/kjlPjGl8hdwPd8MZAW3fG8KzWKywCE4JhbqLsQgAe.";
  users.users.rgruber.hashedPassword = "$6$eaLLB8HjU$fDZ6tylghN2aYHpQ2UUKGpgDVA..buTH4cLaSUzyMVB/kjlPjGl8hdwPd8MZAW3fG8KzWKywCE4JhbqLsQgAe.";
  users.users.root.shell = pkgs.fish;

  users.users.rgruber = {
    isNormalUser = true;
    shell = pkgs.fish;
    home = "/home/rgruber";
    description = "Raphael Gruber";
    extraGroups = [ "wheel" "audio" "input" "video" "docker" "surfaceuser" "networkmanager" "libvirtd" ];
  };
  
}

