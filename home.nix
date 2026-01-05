{ config, pkgs, ... }:

{
  home.username = "marcopist";
  home.homeDirectory = "/home/marcopist";
  home.stateVersion = "25.11";

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "qtwebengine-5.15.19"
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
