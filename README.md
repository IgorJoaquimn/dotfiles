# My Arch Dotfiles

Organized dotfiles for Arch Linux (Hyprland).

## Applications Included
- **Hyprland**: Window manager
- **Waybar**: Status bar
- **Rofi**: Application launcher (Gruvbox theme)
- **Kitty**: Terminal emulator
- **Btop**: Resource monitor
- **Neovim**: Text editor

## Installation
To install these dotfiles, run the provided installation script:

```bash
chmod +x install.sh
./install.sh
```

## Dependencies
Ensure you have the following packages installed:
- `hyprland`
- `waybar`
- `rofi-wayland`
- `kitty`
- `btop`
- `neovim`
- `ttf-firacode-nerd` (for icons)

## Keybindings
The modifier key is set to `SUPER` (Windows key).

| Keybinding | Action |
| --- | --- |
| `SUPER + Q` | Open Terminal (Kitty) |
| `SUPER + R` | Open App Launcher (Rofi) |
| `SUPER + C` | Close Window |
| `SUPER + E` | File Manager (Dolphin) |
| `SUPER + V` | Toggle Floating |
| `SUPER + M` | Exit Hyprland |
| `SUPER + Arrow Keys` | Move Focus |
| `SUPER + [0-9]` | Switch Workspaces |
| `SUPER + SHIFT + [0-9]` | Move Window to Workspace |
| `SUPER + Scroll` | Cycle Workspaces |
| `SUPER + LMB/RMB` | Move/Resize Window |
