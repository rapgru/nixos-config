#with import <nixpkgs> {};
{ stdenv, lib, bash, sway }:

stdenv.mkDerivation rec {
  pname = "sway-run";
  version = "0.1";

  src = ./src;

  installPhase = ''
    install -Dm755 sway-run.sh $out/bin/sway-run
  '';
}
