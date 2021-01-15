{ lib, pkgs, ... } :

{
  services.greetd = {
    enable = true;
    tuigreet = {
      enable = true;
      cmd = "sway-run";
      showTime = true;
      showAsterisks = true;
      customGreeting = "Hello sir! Please log in:";
    }; 
  };
}
