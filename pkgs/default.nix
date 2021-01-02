self: super: {
  greetd = super.callPackage ./greetd {};
  tuigreet = super.callPackage ./tuigreet {};
  sway-run = super.callPackage ./sway-run {};
}
