{ pkgs, lib, ... } :

{

    

    home.packages = let fromNixpkgsCommit = commit: fetchTarball ("https://github.com/NixOS/nixpkgs/archive/" + commit + ".tar.gz"); unstable = import (fromNixpkgsCommit "891f607d5301d6730cb1f9dcf3618bcb1ab7f10e") {}; in with pkgs; [
      vivaldi
      gotop
      discord
      pulsemixer
      #firefox-wayland
      unstable.firefox-wayland
      teams
      jetbrains.idea-ultimate
      jetbrains.phpstorm
      jetbrains.webstorm
      thunderbird
      kdeApplications.dolphin
      custom-waybar-scripts
      signal-desktop
      element-desktop
      spotify
      evince
      schildi-chat
    ];
    programs.alacritty = {
      enable = true;
      settings = {
        shell = { program = "${pkgs.fish}/bin/fish"; };
      };
    };
    programs.vscode = {
      enable = true;
      extensions = with pkgs; [ 
        vscode-extensions.bbenoist.Nix
        #vscode-extensions.mechatroner.rainbow-csv
        #vscode-extensions.marcostazi.vs-code-vagrantfile
        #vscode-extensions.shyykoserhiy.vscode-spotify
        vscode-extensions.james-yu.latex-workshop
        #vscode-extensions.geoffkaile.latex-count
      ] ++ vscode-utils.extensionsFromVscodeMarketplace [
        { name = "better-comments"; publisher = "aaron-bond"; version = "2.1.0";
          sha256 = "0kmmk6bpsdrvbb7dqf0d3annpg41n9g6ljzc1dh0akjzpbchdcwp"; }
        { name = "vscode-duplicate"; publisher = "mrmlnc"; version = "1.2.1";
          sha256 = "1iz9nh19xw3d2c2h0c46dy4ps4gxchaa7spjjgckkc6cg9vxy3cq"; }
        { name = "material-icon-theme"; publisher = "pkief"; version = "4.5.0";
          sha256 = "1mp069j9262ds7f9rx05lhvm85072bx4lyj5nicplmjwwwhf6jwl"; }
        { name = "min-theme"; publisher = "miguelsolorio"; version = "1.4.7";
          sha256 = "00whlmvx4k6qvfyqdmhyx7wvmhj180fh0yb8q4fgdr9bjiawhlyb"; }
        { name = "night-owl"; publisher = "sdras"; version = "2.0.0";
          sha256 = "1s75bp9jdrbqiimf7r36hib64dd83ymqyml7j7726rab0fvggs8b"; }
        { name = "themeswitch"; publisher = "rapgru"; version = "0.1.2";
          sha256 = "0dc8sg84d4l9zzc3m2njk0j12py805bcckvwh5j9hxbf6rw41ahz"; }
        { name = "vscodeintellicode"; publisher = "visualstudioexptteam"; version = "1.2.11";
          sha256 = "057szin28d4sz18b1232xjhf5jjnw2574q34vs3npblhc1jb5y3p"; }
        { name = "remote-containers"; publisher = "ms-vscode-remote"; version = "0.157.0";
          sha256 = "13jjgy4qrspkcarhixg7a221bl8fmslnvn9609a3lfp6lli7gdyi"; }
        { name = "vscode-ltex"; publisher = "valentjn"; version = "8.4.0";
          sha256 = "0b5crc3l17dj6n9dn1gxwh9g0hq9zs9h1w8lsnrssmm1m59vn414"; }
        { name = "vetur"; publisher = "octref"; version = "0.32.0";
          sha256 = "0wk6y6r529jwbk6bq25zd1bdapw55f6x3mk3vpm084d02p2cs2gl"; }
      ];
      haskell = let
        all-hies = import (fetchTarball "https://github.com/infinisil/all-hies/tarball/4b6aab017cdf96a90641dc287437685675d598da") {};
        package = with pkgs; (all-hies.selection { selector = p: { inherit (p) ghc865 ghc882; }; });
      in
      {
        enable = true;
        hie.enable = true;
        hie.executablePath = "${package}/bin/hie-wrapper";
      };
      userSettings = {
       	# == Workbench == #
        "languageServerHaskell.useCustomHieWrapper" = true;
       	"workbench.settings.useSplitJSON" = true;
       	"workbench.settings.openDefaultKeybindings" = true;
       	"workbench.colorTheme" = "Min Light";
       	"workbench.startupEditor" = "newUntitledFile";
        "workbench.editor.limit.enabled" = false;
        "workbench.editor.limit.perEditorGroup" = true;
        "workbench.editor.limit.value" = 3;
       	    
       	 # == Editor == #
         "editor.suggestSelection" = "first";
         "editor.fontFamily" = "Fira Code, Consolas, 'Courier New', monospace";
         "editor.fontLigatures" = true;
         "editor.cursorBlinking" = "phase";
         "editor.cursorStyle" = "line";
         "editor.tabSize" = 2;
         "editor.useTabStops" = false;
         "editor.minimap.enabled" = false;
         "editor.lineNumbers" = "relative";
         "editor.rulers" = [
     	     {
               "column" = 80;
               "color" = "#00ff00";
             }
             100  # <- a ruler in the default color or as customized at column 0
           ]; 
         
         # == Explorer == #
         "explorer.openEditors.visible" = 0;
         
         # == Files == #
         "files.eol" = "\n";
         "files.autoSaveDelay" = 1000;
         "files.autoSave" = "afterDelay";
         
         # == NPM == #
         "npm.enableScriptExplorer" = true;
      
         # == Git == #
         "git.enableSmartCommit" = true;
         
         # == Window == #
         "window.zoomLevel" = 0;
         
         # -- IntelliCode -- #
         "vsintellicode.modify.editor.suggestSelection" = "automaticallyOverrodeDefaultValue";
         
         # -- ThemeSwitch -- #
         "themeswitch.directives" = [
     	   {
             "time" = "20:00";
             "theme" = "Min Dark";
           }
           {
             "time" = "07:00";
             "theme" = "Min Light";
           }
         ];
      
         # -- Latex -- #
         "latex-workshop.view.pdf.viewer" = "tab";
         "ltex.language" = "de-AT";
         "vim.easymotion" = true;
         "vim.easymotionMarkerBackgroundColor" = "#232323";
      };
    };
    programs.fish = {
      enable = true; 
    };
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
      };
    };
}
