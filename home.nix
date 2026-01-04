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
          size = {
            width = 200;
            height = 50;
          };
          outline_thickness = 3;
          dots_size = 0.2;
          dots_spacing = 0.2;
          dots_center = true;
          dots_rounding = -1;
          outer_color = "rgb(151515)";
          inner_color = "rgb(200, 200, 200)";
          font_color = "rgb(10, 10, 10)";
          fade_on_empty = true;
          fade_timeout = 1000;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          rounding = -1;
          check_color = "rgb(204, 136, 34)";
          fail_color = "rgb(204, 55, 55)";
          fail_text = "<i>$ATTEMPTS Failed</i>";
          fail_timeout = 2000;
          fail_transition = 300;
          capslock_color = -1;
          numlock_color = -1;
          bothlock_color = -1;
          invert_numlock = false;
          swap_font_color = false;
          shadow_passes = 2;
          shadow_size = 10;
          shadow_color = "rgba(0, 0, 0, 1.0)";
          shadow_boost = 1.2;
          position = {
            x = 0;
            y = 0;
          };
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +%H:%M:%S)\"";
          color = "rgba(255, 255, 255, 1.0)";
          font_size = 55;
          font_family = "FiraCode Nerd Font";
          position = {
            x = 0;
            y = 80;
          };
          halign = "center";
          valign = "top";
        }
      ];
    };
  };

  # Configure swayidle
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.hyprlock}/bin/hyprlock";
      }
      {
        event = "after-resume";
        command = "hyprctl dispatch dpms on";
      }
    ];
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
