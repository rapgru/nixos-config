#with import <nixpkgs> {};

 { stdenv
 , rustPlatform
 , makeWrapper
 , fetchFromGitHub
 } :

rustPlatform.buildRustPackage rec {
  pname="surface-control";
  version="0.3.0-1";

  src = fetchFromGitHub {
    owner = "linux-surface";
    repo = "surface-control";
    rev = "v${version}";
    sha256 = "1acbfrsrpar78k8sx7nl34nphsqbf9z2fa4ipwdx3vms4h9bphra";
  };
  cargoSha256 = "0h1s29rqdi0c4i769nd6q1kflxmw615ysqjh6pdv5h0n9dnk0w9f";
  
}
