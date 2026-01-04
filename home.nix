{ config, pkgs, ... }:

{
  home.username = "marcopist";
  home.homeDirectory = "/home/marcopist";
  home.stateVersion = "25.11";

  # Environment variables for Wayland/Hyprland
  home.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  # User packages (including fonts)
  home.packages = with pkgs; [
    # Development
    neovim
    nodejs
    gh

    # GUI applications
    firefox

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
    wpctl
    playerctl

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
  };

  # Enable Home Manager
  programs.home-manager.enable = true;
}
