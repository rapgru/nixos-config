#with import <nixpkgs> {};
{ stdenv, lib, bash, surface-control }:

stdenv.mkDerivation rec {
  pname = "custom-waybar-scripts";
  version = "0.1";

  src = ./src;

  buildInputs = [ surface-control ];

  installPhase = ''
    install -Dm755 surface-mode.sh $out/bin/surface-mode.sh
  '';
}
