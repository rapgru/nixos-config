self: super: {
  greetd = super.callPackage ./greetd {};
  tuigreet = super.callPackage ./tuigreet {};
  sway-run = super.callPackage ./sway-run {};
  iptsd = super.callPackage ./iptsd {};
  inih = super.callPackage ./inih {};
  surface-control = super.callPackage ./surface-control {};
  custom-waybar-scripts = super.callPackage ./custom-waybar-scripts {};
  schildi-chat = super.callPackage ./schildi-chat {};
  udiskie-wayland = super.callPackage ./udiskie-wayland {};
}
