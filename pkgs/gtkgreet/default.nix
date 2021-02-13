#with import <nixpkgs> {};

 { stdenv
 , ninja
 , meson 
 , fetchurl
 , gtk3
 , json_c
 , gtk-layer-shell
 , scdoc
 , pkgconfig
 } :

stdenv.mkDerivation rec {
  pname="gtkgreet";
  version="0.7";
  src = fetchurl {
    url = "https://git.sr.ht/~kennylevinsen/gtkgreet/archive/${version}.tar.gz";
    sha256 = "0wwkmp5zx1mv0vy8qqijf0kw48bmz4ivjcmrwy68ikzrwkhs0jzb";
  };

  nativeBuildInputs = [ meson ninja pkgconfig ]; 
  
  buildInputs = [ gtk3 json_c gtk-layer-shell scdoc ];

  
}
