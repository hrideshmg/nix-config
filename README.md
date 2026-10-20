# nix-config

Flake-based NixOS + Home Manager config for two hosts.

| Host | User | Role |
| --- | --- | --- |
| `zenbook14` | `hridesh` | Laptop, daily driver |
| `workstation` | `operator` | Home server (VNC, Syncthing, VPN) |

## Structure

```
flake.nix            # inputs + both nixosConfigurations
hosts/<host>/        # per-host NixOS config, hardware, monitors
nix_modules/         # shared NixOS modules (system, hyprland, bluetooth, vpn, syncthing, ...)
users/<user>/home.nix  # per-user Home Manager entry point, picks which home_modules to import
home_modules/
  base/              # cross-host essentials (git, browsers, media, common packages)
  shell/             # fish, tmux, foot, direnv
  hyprland/          # WM config, waybar, rofi, dunst, hyprpaper, swaylock
  programs/          # reusable standalone programs (coding agents, zathura, stremio)
nvim/                # Neovim as its own flake (nixCats), consumed as an input
secrets/             # git-crypt encrypted
wallpapers/
```

## Programs

| Category | Programs |
| --- | --- |
| Window manager | Hyprland, waybar, rofi, dunst, hyprpaper, swaylock-effects, grimblast |
| Shell / terminal | fish, tmux, foot, zoxide, direnv, fastfetch |
| Editor | Neovim (nixCats) |
| Browsers | Firefox, Chromium |
| Dev | git, gh, docker, devenv, python3, bruno, ngrok, mprocs |
| Coding agents | Claude Code, opencode |
| Nix tooling | nh, nix-index, git-crypt |
| Media | mpv, Spotify, Stremio, playerctl, pavucontrol, OBS |
| Productivity | Obsidian, KeePassXC, OnlyOffice, zathura |
| Files / utils | nemo, imv, btop, ncdu, tldr |
| Communication | Discord |
| Networking | Tailscale, NetBird, Syncthing, wayvnc + noVNC, cloudflared (workstation) |
