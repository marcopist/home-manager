{ config, pkgs, ... }:

{
  home.username = "marcopist";
  home.homeDirectory = "/home/marcopist";
  home.stateVersion = "25.11";

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
    neovim
    nodejs
    gh

    # GUI applications

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
      };
    };
  };

  # Enable Home Manager
  programs.home-manager.enable = true;
}
