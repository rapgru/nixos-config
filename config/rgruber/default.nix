{ pkgs, lib, ... } :

let
  colors = (import ./colors.nix);
  fromNixpkgsCommit = commit: fetchTarball ("https://github.com/NixOS/nixpkgs/archive/" + commit + ".tar.gz");
  unstable = import (fromNixpkgsCommit "891f607d5301d6730cb1f9dcf3618bcb1ab7f10e") {};
in
{
    home.packages = let  in with pkgs; [
      vivaldi
      gotop
      discord
      pulsemixer
      #firefox-wayland
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
      texlive.combined.scheme-full
      udiskie-wayland
      any-nix-shell
      ranger
      chromium
      #breeze-icons
      adwaita-qt
      xdg_utils
      gimp
    ];
    home.file.".mozilla/firefox/default/search.json.mozlz4".source = ./search.json.mozlz4;
    programs.firefox = {
      enable = true;
      package = unstable.firefox-wayland;
      extensions = with pkgs.nur.repos.rycee.firefox-addons; [
        ublock-origin
        lastpass-password-manager
      ];
      profiles.default = {
        id = 0;
        isDefault = true;
        name = "default";
        settings = {
          "browser.urlbar.placeholderName" = "DuckDuckGo";
          "browser.newtabpage.pinned" = "[{\"url\":\"https://google.com\",\"label\":\"@google\",\"searchTopSite\":true}]";
          "browser.newtabpage.activity-stream.improvesearch.topSiteSearchShortcuts.havePinned" = "google";
          "browser.search.region" = "AT";
          "browser.startup.page" = 3;
          "devtools.theme" = "dark";
          "widget.content.gtk-theme-override" = "Nordic";
          "signon.rememberSignons" = false;
          "widget.content.allow-gtk-dark-theme" = true;
          "toolkit.telemetry.enabled" = false;
          "browser.newtabpage.activity-stream.enabled" = false;
          "extensions.pocket.enabled" = false;
          "app.normandy.enabled" = false;
          "app.normandy.api_url" = "";
          "app.shield.optoutstudies.enabled" = false;
          "browser.sessionstore.max_tabs_undo" = 25;
          "browser.sessionstore.max_windows_undo" = 3;
          "browser.search.firstRunSkipsHomepage" = true;
          "datareporting.healthreport.uploadEnabled" = false;
          "datareporting.healthreport.service.enabled" = false;
          "datareporting.policy.dataSubmissionEnabled" = false;
          "browser.shell.checkDefaultBrowser" = false;
        };
        userChrome = ''
          @-moz-document url(chrome://browser/content/browser.xul),
               url(chrome://browser/content/browser.xhtml)
          {
            /*** TAB BAR ***/
            /* Ensure tab doesn't show through auto-completion popup */
            .tabbrowser-tab { z-index: 0 !important; }
            /* Ensure tab "spacers" don't show through the completion window */
            #tabbrowser-arrowscrollbox > spacer { z-index: -1 !important; }
            #mainPopupSet { z-index: 9999 !important; }
          
            /* Hide tabbar if only one tab */
            @import url(./css/tabs-hide-if-only-one.css);
          
            /* Remove the colored overline on the focused tab */
            .tabbrowser-tab .tab-line { background: none !important; }
          
            /* Replace favicon on tabs with close button on mouse hover */
            .tabbrowser-tab:not(:hover) .tab-close-button,
            .tabbrowser-tab:not([pinned]):hover .tab-icon-image { display: none !important; }
            .tabbrowser-tab:not([pinned]):hover .tab-close-button { display:block !important; }
          
            .tabbrowser-tab:hover .tab-throbber,
            .tabbrowser-tab:hover .tab-icon-image,
            .tabbrowser-tab:hover .tab-sharing-icon-overlay,
            .tabbrowser-tab:hover .tab-icon-overlay,
            .tabbrowser-tab:hover .tab-label-container,
            .tabbrowser-tab:hover .tab-icon-sound {
              -moz-box-ordinal-group: 2 !important;
            }
          
            .tabbrowser-tab .tab-close-button {
              margin-left: -2px !important;
              margin-right: 4px !important;
            }
          
            .tab-close-button:hover {
              fill-opacity: 0 !important;
            }
          
            .tabbrowser-tab::after,
            .tabbrowser-tab::before {
              border-left: none !important;
              border-right: none !important;
            }
          
            .scrollbutton-up[orient="horizontal"]~spacer { border-width: 0px; opacity: 0 }
          
            scrollbar {
              -moz-appearance: none !important;
              display: none !important;
            }
          
            /*** NAV BAR ***/
            /* Hide urlbar */
            #nav-bar {
              position: relative !important;
              z-index: 2 !important;
              height: 2px !important;
              min-height: 2px !important;
              margin-bottom: -2px !important;
              opacity: 0 !important;
              border: none !important;
            }
          
            /* But unfocus it when we invoke it with ctrl+L */
            #nav-bar:focus-within {
              height: auto !important;
              margin-bottom: 0px !important;
              opacity: 1 !important;
              overflow: show !important;
            }
          
            #urlbar-container {
              min-height: 0 !important;
            }
          
            #urlbar {
              top: 0 !important;
            }
          
            #urlbar-input-container {
              height: 28px !important;
            }
          
            /*** Load local overrides ***/
            @import url(./userChrome.local.css);
          }
        '';
      };
    };
    services.nextcloud-client.enable = true;
    programs.alacritty = {
      enable = true;
      settings = {
        shell = { program = "${pkgs.fish}/bin/fish"; };
	colors = {
          primary = {
            background= "#2e3440";
            foreground= "#d8dee9";
            dim_foreground= "#a5abb6";
          };
          cursor = {
            text= "#2e3440";
            cursor= "#d8dee9";
          };
          vi_mode_cursor = {
            text= "#2e3440";
            cursor= "#d8dee9";
          };
          selection = {
            text= "CellForeground";
            background= "#4c566a";
          };
          search = {
            matches = {
              foreground= "CellBackground";
              background= "#88c0d0";
            };
            bar = {
              background= "#434c5e";
              foreground= "#d8dee9";
            };
          };
          normal = {
            black= "#3b4252";
            red= "#bf616a";
            green= "#a3be8c";
            yellow= "#ebcb8b";
            blue= "#81a1c1";
            magenta= "#b48ead";
            cyan= "#88c0d0";
            white= "#e5e9f0";
          };
          bright = {
            black= "#4c566a";
            red= "#bf616a";
            green= "#a3be8c";
            yellow= "#ebcb8b";
            blue= "#81a1c1";
            magenta= "#b48ead";
            cyan= "#8fbcbb";
            white= "#eceff4";
          };
          dim = {
            black= "#373e4d";
            red= "#94545d";
            green= "#809575";
            yellow= "#b29e75";
            blue= "#68809a";
            magenta= "#8c738c";
            cyan= "#6d96a5";
            white= "#aeb3bb";
          };
        };
      };
    };
    # for nextcloud client
    services.gnome-keyring.enable = true;
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
      promptInit = ''
        any-nix-shell fish --info-right | source
      '';
    };
    xdg = {
      enable = true;
      userDirs = {
        enable = true;
        documents = "\$HOME/Nextcloud/Dokumente";
        pictures = "\$HOME/Nextcloud/Bilder";
      };
    };
}
