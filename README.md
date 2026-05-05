# My Arch Dotfiles

Organized dotfiles for Arch Linux (Hyprland).

## Applications Included
- **Hyprland**: Window manager
- **Waybar**: Status bar
- **Rofi**: Application launcher (Gruvbox theme)
- **Kitty**: Terminal emulator
- **Btop**: Resource monitor
- **Neovim**: Text editor
- **Thunar**: Graphical file manager
- **Yazi**: Terminal file manager
- **SwayNC**: Notification daemon and control center
- **qimgv**: Image viewer
- **MPV**: Video player
- **Hyprshot**: Screenshot utility
- **Split Monitor Workspaces**: Hyprland plugin for independent workspaces

## Setup on a New PC

### 1. Install an AUR Helper (yay)
If you don't have `yay` installed yet, run:
```bash
sudo pacman -S --needed base-devel git
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
```

### 2. Clone the Repository
```bash
git clone https://github.com/IgorJoaquimn/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

### 3. Run the Installation Script
This script will install all dependencies, link configuration files, setup the daily wallpaper service, and configure Hyprland plugins.
```bash
chmod +x install.sh
./install.sh
```

## Keybindings
The modifier key is set to `SUPER` (Windows key).

| Keybinding | Action |
| --- | --- |
| `SUPER + Q` | Open Terminal (Kitty) |
| `SUPER + R` | Open App Launcher (Rofi) |
| `SUPER + C` | Close Window |
| `SUPER + E` | File Manager (Thunar) |
| `SUPER + Y` | Terminal File Manager (Yazi) |
| `SUPER + V` | Toggle Floating |
| `SUPER + M` | Exit Hyprland |
| `SUPER + F` | Fullscreen Tile |
| `Print` | Screenshot (Fullscreen) |
| `SUPER + Print` | Screenshot (Window) |
| `SUPER + SHIFT + Print` | Screenshot (Region) |
| `SUPER + Arrow Keys` | Move Focus |
| `SUPER + [0-9]` | Switch Workspaces (Independent per monitor) |
| `SUPER + SHIFT + [0-9]` | Move Window to Workspace |
| `SUPER + Scroll` | Cycle Workspaces |
| `SUPER + LMB/RMB` | Move/Resize Window |

## Daily Wallpapers
The system automatically fetches a "Classical Art" wallpaper from Wallhaven every day and on every login. 
- Manual reload: `reload_wallpaper.sh`
