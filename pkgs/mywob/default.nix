#with import <nixpkgs> {};
{ stdenv, lib, bash, sway, wob }:

stdenv.mkDerivation rec {
  pname = "mywob";
  version = "0.2";

  src = ./src;

  buildInputs = [ sway wob ];

  installPhase = ''
    install -Dm755 mywob.sh $out/bin/mywob
  '';
}
