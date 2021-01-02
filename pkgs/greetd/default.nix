#with import <nixpkgs> {};
{ stdenv
, fetchurl
, rustPlatform
, makeWrapper
, linux-pam
}:

rustPlatform.buildRustPackage rec {
  pname = "greetd";
  version = "0.7.0";
  src = fetchurl {
    url = "https://git.sr.ht/~kennylevinsen/greetd/archive/${version}.tar.gz";
    sha256 = "c84214490479f291ed3f27424e6c020a9f3115f5745c90a05f7508999b1b69a3";
  };

  buildInputs = [ linux-pam ];

  nativeBuildInputs = [ makeWrapper ];

  cargoSha256 = "148vhm23lv1q4hz7z8qm5pgxsf4ajnfbcwrsznv0dp9lhyn7r9y3";
}
