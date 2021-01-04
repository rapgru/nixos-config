self: super: {
  greetd = super.callPackage ./greetd {};
  tuigreet = super.callPackage ./tuigreet {};
  sway-run = super.callPackage ./sway-run {};
  iptsd = super.callPackage ./iptsd {};
  inih = super.callPackage ./inih {};
}
