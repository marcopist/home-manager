{ config, pkgs, ... }:

let
  pkgs-24-05 = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/nixos-24.05.tar.gz";
    sha256 = "0zydsqiaz8qi4zd63zsb2gij2p614cgkcaisnk11wjy3nmiq0x1s";
  }) {
    system = pkgs.system;
    config = {
      allowUnfree = true;
      permittedInsecurePackages = [
        "webkitgtk-4.0.37"
      ];
    };
  };
in
{
  home.username = "marcopist";
  home.homeDirectory = "/home/marcopist";
  home.stateVersion = "25.11";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
    "libsoup-2.74.3"
  ];
  # Environment variables for Wayland/Hyprland
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    GTK_THEME = "Adwaita:dark";
    QT_STYLE_OVERRIDE = "adwaita-dark";
    COLORFGBG = "15;8";
  };

  home.pointerCursor = {
    name = "Bibata-Modern-Classic";
    size = 24;

    package = pkgs.bibata-cursors;

    # compatibility (GTK apps / XWayland often still use Xcursor)
    gtk.enable = true;
    x11.enable = true;
  };


  # User packages (including fonts)
  home.packages = with pkgs; [
    # Development
    vscode
    neovim
    nodejs
    gh

    # GUI applications
    spotify
    (citrix_workspace.overrideAttrs (old: {
      src = pkgs.requireFile {
        name = "linuxx64-25.08.10.111.tar.gz";
        sha256 = "6dddc2971051260be3256fb068a044df593d78f6a6fa7da91de4a3964be40d1a";
        message = "Please add the Citrix tarball to the nix store.";
      };
      meta = old.meta // { broken = false; };
      buildInputs = (old.buildInputs or []) ++ [ 
        pkgs.fuse3 
        pkgs-24-05.webkitgtk
      ];
      postInstall = ''
        # Manually patch the binary to use libfuse3.so.4 instead of .3
        chmod +w $out/opt/citrix-icaclient/ctxfuse
        patchelf --replace-needed libfuse3.so.3 libfuse3.so.4 $out/opt/citrix-icaclient/ctxfuse
      '' + (old.postInstall or "");
    }))

    # Audio tools and enhancements
    alsa-utils
    alsa-plugins
    easyeffects

    # Display management
    wdisplays
    
    # Wayland/Hyprland tools
    hyprland
    waybar
    kitty
    wofi
    dunst
    grim
    slurp
    wl-clipboard
    xdg-utils
    thunar
    brightnessctl
    wireplumber
    playerctl
    swww
    hyprlock
    swayidle

    # Cursor theme
    bibata-cursors

    # Fonts
    nerd-fonts.fira-code
    nerd-fonts.jetbrains-mono
    nerd-fonts.symbols-only
  ];

  # Enable fontconfig
  fonts.fontconfig.enable = true;

  # Link configuration files
  home.file = {
    ".config/hypr/hyprland.conf".source = ./config/hypr/hyprland.conf;
    ".config/kitty/kitty.conf".source = ./config/kitty/kitty.conf;
    ".config/waybar/config".source = ./config/waybar/config.jsonc;
    ".config/waybar/style.css".source = ./config/waybar/style.css;
    ".config/wallpapers/wallpaper.jpg".source = ./config/wallpapers/wallpaper.jpg;
  };

  # Configure waybar
  programs.waybar = {
    enable = true;
  };

  # Configure Firefox
  programs.firefox = {
    enable = true;
    profiles.default = {
      settings = {
        "ui.systemUsesDarkTheme" = 1;
        "browser.in-content.dark-mode" = true;
        # Disable sponsored content and recommendations
        "extensions.pocket.enabled" = false;
        "browser.newtabpage.activity-stream.showSponsored" = false;
        "browser.newtabpage.activity-stream.showRecommendations" = false;
        "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
      };
    };
  };

  # Configure swayidle
  services.swayidle = {
    enable = true;
    events = {
      before-sleep = "${pkgs.hyprlock}/bin/hyprlock";
      after-resume = "hyprctl dispatch dpms on";
    };
    timeouts = [
      {
        timeout = 900; # 15 minutes
        command = "hyprctl dispatch dpms off";
        resumeCommand = "hyprctl dispatch dpms on";
      }
      {
        timeout = 1200; # 20 minutes
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };

  # Enable Home Manager
  programs.home-manager.enable = true;
}
