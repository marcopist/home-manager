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
      };
    };
  };

  # Configure hyprlock
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        hide_cursor = true;
        grace = 0;
        no_fade_out = false;
      };

      background = [
        {
          monitor = "";
          path = "$HOME/.config/wallpapers/wallpaper.jpg";
          blur_passes = 3;
          blur_size = 8;
          noise = 0.02;
          contrast = 0.8;
          brightness = 0.8;
          vibrancy = 0.1;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "200, 50";
          position = "0, 0";
          outline_thickness = 3;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          outer_color = "0xFF1A1A1AFF";
          inner_color = "0xFFC8C8C8FF";
          font_color = "0xFF0A0A0AFF";
          fade_on_empty = true;
          fade_timeout = 1000;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          check_color = "0xFFCC8822FF";
          fail_color = "0xFFCC3737FF";
          fail_text = "<i>$FAIL</i>";
          fail_timeout = 2000;
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +%H:%M:%S)\"";
          color = "0xFFFFFFFFFF";
          font_size = 55;
          font_family = "FiraCode Nerd Font";
          position = "0, 80";
          halign = "center";
          valign = "top";
        }
      ];
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
