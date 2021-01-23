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
      thunderbird
      kdeApplications.dolphin
      custom-waybar-scripts
    ];
    programs.alacritty = {
      enable = true;
    };
    programs.vscode = {
      enable = true;
      extensions = [ pkgs.vscode-extensions.bbenoist.Nix ];
    };
    programs.fish = {
      enable = true; 
    };
}
