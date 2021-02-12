{ pkgs, fetchurl, appimageTools }:


let
  name = "SchildiChat"; 
  version = "1.7.17-sc1";
  src = fetchurl { 
    url = "https://github.com/SchildiChat/schildichat-desktop/releases/download/v${version}/SchildiChat-${version}.AppImage";
    sha256 =  "sha256:1b7crddwp74gsbh7i3dal3ppnhd5gv0rz7md82732brp780nzmrk";
  };
in appimageTools.wrapType2 rec {
  inherit name src;
  extraPkgs = pkgs: with pkgs; [ ]; 
}
