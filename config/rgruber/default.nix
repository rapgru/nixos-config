{ pkgs, lib, ... } :

{
    home.packages = with pkgs; [
      vivaldi
      gotop
      discord
      pulsemixer
      firefox-wayland
      teams
      jetbrains.idea-ultimate
      jetbrains.phpstorm
      jetbrains.webstorm
    ];
    programs.alacritty = {
      enable = true;
    };
    programs.vscode = {
      enable = true;
      extensions = [ pkgs.vscode-extensions.bbenoist.Nix ];
    };
}
