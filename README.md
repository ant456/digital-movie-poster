# Digital Movie Poster

A Raspberry Pi-based digital movie poster display that integrates with Plex, Jellyfin, and Kodi to show beautiful movie posters on your TV or monitor. Supports live "now playing" detection and automatic poster rotation.

## Features

- 🎬 Automatic poster art syncing from your media server
- 📺 Live "now playing" detection via Plex, Jellyfin, or Kodi
- 🔄 Smooth poster rotation and transitions
- 🖥️ Kiosk mode — boots straight into fullscreen display
- ⭐ Movie ratings, runtime, audio format badges
- 🎵 Theme music support

## Requirements

- Raspberry Pi 4 or 5 (recommended)
- Raspberry Pi OS Bookworm (Debian 12) — 64-bit
- TMDB API key (free at themoviedb.org)
- Plex, Jellyfin, or Kodi media server

## Stack

- PHP 8.5 / Laravel 10
- Vue 3 / Vite 5
- Node 20 / Socket.IO 4.7
- MariaDB 10.11
- Redis
- Apache 2

## Fresh Install (Raspberry Pi)

Flash a fresh SD card with **Raspberry Pi OS Bookworm** using Raspberry Pi Imager.

SSH into your Pi, then:

```bash
wget https://raw.githubusercontent.com/YOUR_USERNAME/digital-movie-poster/main/install.sh
chmod +x install.sh
sudo bash install.sh YOUR_USERNAME
```

The script will install everything automatically and reboot into kiosk mode (~15 minutes).

## Post-Install Configuration

Visit `http://your-pi-ip` in a browser and go to **Settings** to configure:

- TMDB API key
- Plex/Jellyfin/Kodi connection
- Poster rotation speed
- Display options

## Updating

```bash
cd /var/www/html
sudo bash update.sh
```

## Accessing the UI

From any browser on your network:
```
http://your-pi-ip
```

## Credits

Originally based on [devMikeFrancis/digital-movie-poster](https://github.com/devMikeFrancis/digital-movie-poster).
Updated for modern Linux (Bookworm), PHP 8.5, Node 20, Laravel 10, and Vite 5.
