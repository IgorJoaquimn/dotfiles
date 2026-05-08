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
- **Dunst**: Notification daemon (Gruvbox theme)
- **Zsh & Starship**: Modern shell with Zinit, FZF, and autosuggestions
- **qimgv**: Image viewer
- **MPV**: Video player
- **Hyprshot**: Screenshot utility
- **Split Monitor Workspaces**: Hyprland plugin for independent workspaces
- **SDDM**: Login manager with Pixel-Coffee theme (Synced with daily wallpaper)

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

## Machine-Specific Configuration (Local Sourcing)
To handle differences between PCs (like inverted scroll or different monitors), this repo uses a "Local Sourcing" pattern.

### Hyprland
Create a file at `~/.config/hypr/local.conf`. This file is ignored by Git, so you can put hardware-specific settings there.
Example for Laptop:
```hypr
input {
    touchpad {
        natural_scroll = true
        scroll_factor = 0.8
    }
}
```

### Shell
If you need local aliases or environment variables, create `~/.bashrc_local` or `~/.zshrc_local` and they will be ignored by Git.

## Keybindings
The modifier key is set to `SUPER` (Windows key).

| Keybinding | Action |
| --- | --- |
| `SUPER + T` | Open Terminal (Kitty) |
| `SUPER + R` | Open App Launcher (Rofi) |
| `SUPER + Q` | Close Window |
| `SUPER + W` | Maximize Window |
| `SUPER + H / J / K / L` | Move / Swap Window (Left / Down / Up / Right) |
| `SUPER + SHIFT + H / J / K / L` | Resize Window (Left / Down / Up / Right) |
| `SUPER + Arrow Keys` | Move Focus |
| `SUPER + E` | File Manager (Thunar) |
| `SUPER + Y` | Terminal File Manager (Yazi) |
| `SUPER + V` | Toggle Floating |
| `SUPER + M` | Exit Hyprland |
| `SUPER + F` | Fullscreen Tile |
| `SUPER + N` | Next Wallpaper |
| `Print` | Screenshot (Fullscreen) |
| `SUPER + Print` | Screenshot (Window) |
| `SUPER + SHIFT + Print` | Screenshot (Region) |
| `SUPER + [0-9]` | Switch Workspaces (Independent per monitor) |
| `SUPER + SHIFT + [0-9]` | Move Window to Workspace |
| `SUPER + Scroll` | Cycle Workspaces |
| `SUPER + LMB/RMB` | Move/Resize Window |

## Daily Wallpapers
The system automatically fetches a "Classical Art" wallpaper from Wallhaven every day and on every login. 
- Manual reload: `reload_wallpaper.sh`
