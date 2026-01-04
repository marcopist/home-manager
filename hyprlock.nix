{ config, pkgs, ... }:

{
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
          brightness = 0.6;
          vibrancy = 0.1;
          vibrancy_darkness = 0.0;
        }
      ];

      input-field = [
        {
          monitor = "";
          size = "300, 60";
          position = "0, -120";
          outline_thickness = 4;
          dots_size = 0.33;
          dots_spacing = 0.15;
          dots_center = true;
          outer_color = "0xFFFFFFFF";
          inner_color = "0xFF000000";
          font_color = "0xFFFFFFFF";
          fade_on_empty = true;
          fade_timeout = 1000;
          placeholder_text = "<i>Password...</i>";
          hide_input = false;
          check_color = "0xFF00FF00";
          fail_color = "0xFFFF0000";
          fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
          fail_timeout = 2000;
          halign = "center";
          valign = "center";
        }
      ];

      label = [
        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(date +%H:%M:%S)\"";
          color = "0xFFFFFFFF";
          font_size = 48;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -80";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "cmd[update:60000] echo \"$(date +\"%A, %B %d\")\"";
          color = "0xFFFFFFFF";
          font_size = 16;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, -30";
          halign = "center";
          valign = "center";
        }
        {
          monitor = "";
          text = "Welcome Marco";
          color = "0xFFFFFFFF";
          font_size = 24;
          font_family = "JetBrainsMono Nerd Font";
          position = "0, 50";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
