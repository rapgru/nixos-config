{ lib, pkgs, ... } :

{
  users.mutableUsers = false;
  users.users.root.hashedPassword = "$6$eaLLB8HjU$fDZ6tylghN2aYHpQ2UUKGpgDVA..buTH4cLaSUzyMVB/kjlPjGl8hdwPd8MZAW3fG8KzWKywCE4JhbqLsQgAe.";
  users.users.rgruber.hashedPassword = "$6$eaLLB8HjU$fDZ6tylghN2aYHpQ2UUKGpgDVA..buTH4cLaSUzyMVB/kjlPjGl8hdwPd8MZAW3fG8KzWKywCE4JhbqLsQgAe.";

  users.users.rgruber = {
    isNormalUser = true;
    home = "/home/rgruber";
    description = "Raphael Gruber";
    extraGroups = [ "wheel" "audio" "video" "docker" ];
  };
}

