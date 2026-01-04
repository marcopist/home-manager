# System Organization

NixOS home-manager config for Wayland desktop (Hyprland).

## Structure

- **flake.nix**: Dependency management (nixpkgs, home-manager)
- **home.nix**: Main config - packages, fonts, session variables, links config files
- **config/**: Application dotfiles (hypr, kitty, waybar) - symlinked to ~/.config/

## Apply Changes

```
home-manager switch
```
