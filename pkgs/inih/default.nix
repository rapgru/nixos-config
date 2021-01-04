{ stdenv, fetchFromGitHub, meson, ninja }:

stdenv.mkDerivation rec {
  pname = "inih";
  version = "r52";

  src = fetchFromGitHub {
    owner = "benhoyt";
    repo = pname;
    rev = version;
    sha256 = "0lsvm34zabvi1xlximybzvgc58zb90mm3b9babwxlqs05jy871m4";
  };

  nativeBuildInputs = [ meson ninja ];

  mesonFlags = [
    "-Ddefault_library=shared"
    "-Ddistro_install=true"
    "-Dwith_INIReader=true"
  ];
  
  # this package is copied from nixpkgs master
}
