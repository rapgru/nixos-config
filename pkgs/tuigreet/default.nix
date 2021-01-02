#with import <nixpkgs> {};

 { stdenv
 , rustPlatform
 , makeWrapper
 , fetchFromGitHub
 } :

rustPlatform.buildRustPackage rec {
  pname="tuigreet";
  version="0.2.0";

  src = fetchFromGitHub {
    owner = "apognu";
    repo = "tuigreet";
    rev = "${version}";
    sha256 = "1fk8ppxr3a8vdp7g18pp3sgr8b8s11j30mcqpdap4ai14v19idh8";
  };
  cargoSha256 = "0qpambizjy6z44spnjnh2kd8nay5953mf1ga2iff2mjlv97zpq22";
  
}
