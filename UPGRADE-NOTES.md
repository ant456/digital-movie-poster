# Upgrade Notes — 2024/2025 Modernization

## Summary of Changes

This upgrade brings the project up to date with modern Linux (Raspberry Pi OS Bookworm),
PHP 8.2, Node 20 LTS, Laravel 10, and Vite 5.

---

## Raspberry Pi OS

**Flash a fresh SD card with Raspberry Pi OS Bookworm (Debian 12).**
Do not attempt to upgrade Bullseye in-place — the Raspberry Pi Foundation advises against it.
Use Raspberry Pi Imager to flash a new Bookworm image.

---

## Files Changed

### `composer.json`
- PHP bumped to `^8.2` (8.0/8.1 are EOL)
- Laravel bumped to `^10.0`
- **Removed** `fruitcake/laravel-cors` (abandoned; merged into Laravel core)
- `laravel/sanctum` → `^3.3`
- `opcodesio/log-viewer` → `^3.4`
- `predis/predis` → `^2.2`
- `doctrine/dbal` → `^3.6`
- Dev deps updated: breeze, collision, phpunit (10.x), ignition (2.x)
- Added `allow-plugins` config (required by Composer 2.2+)

### `app/Http/Kernel.php`
- Replaced `\Fruitcake\Cors\HandleCors::class` with `\Illuminate\Http\Middleware\HandleCors::class`
  (Laravel 10 ships this natively; config/cors.php still applies)

### `package.json`
- **Vite** 3 → 5
- **laravel-vite-plugin** 0.6 → 1.0
- **@vitejs/plugin-vue** 3 → 5
- **axios** 0.27 → 1.x (see note below)
- **Vue** → 3.4+
- **tailwindcss** → 3.4
- **pinia** → 2.1
- **socket.io-client** → 4.7
- Removed `@vue/compat` (migration build no longer needed)
- Removed `socketserver: file:socketserver` local dep (caused npm install issues)

### `resources/js/Views/PostersEdit.vue`
- Removed manual `Content-Type: multipart/form-data` header from axios call.
  In axios 1.x, setting this header manually removes the required `boundary` parameter,
  breaking file uploads. axios now sets it automatically when passed a FormData object.

### `socketserver/package.json`
- `socket.io` → 4.7
- Removed `http` stub package (was a security placeholder, not needed)
- Added `engines: { node: ">=20.0.0" }`
- Added `start` script

### `docker-compose.yml`
- Build context changed from `./docker/8.1` → `./docker/8.2`
- MariaDB image bumped from `mariadb:10` → `mariadb:10.11` (10.11 is the current LTS)

### `docker/8.2/Dockerfile`
- `NODE_VERSION` 16 → **20**
- `python2` → **python3-minimal** (python2 removed in Ubuntu 22.04+)
- `POSTGRES_VERSION` 14 → 15
- Added `php8.2-redis` and `php8.2-igbinary` extensions (were commented out)
- NodeSource setup URL updated to use `curl -fsSL` (more reliable)

### `install.sh`
- PHP 8.1 → **PHP 8.2** throughout
- Node 16 → **Node 20 LTS** (16 is EOL)
- `chromium-browser` → **`chromium`** (package renamed on Bookworm)
- `python2` → `python3` (for hdmi-control.py)
- Added graceful fallbacks (`|| true`) for `chmod /dev/vchiq` and `raspi-config`
  (these can fail on non-Pi hardware without breaking the install)
- Fixed: removed deprecated `a2dismod php7.4` call

### `update.sh`
- Cleaned up to match new stack; added socketserver PM2 restart step

---

## ⚠️ Things You Still Need to Do Manually

### 1. Laravel 10 upgrade steps
After running `composer install`, check these Laravel 9→10 breaking changes:
- Run `php artisan vendor:publish --tag=sanctum-migrations` and check for new migrations
- Review [Laravel 10 Upgrade Guide](https://laravel.com/docs/10.x/upgrade)
- If using `intervention/image`, it stays on v2.x — do NOT upgrade to v3 without significant refactoring

### 2. Axios 1.x error handling
If you have custom `.catch()` handlers checking `error.response` vs `error.request`,
those still work the same. The main change was FormData headers (already fixed above)
and that axios 1.x no longer throws on 4xx/5xx by default if you set `validateStatus`.
Test your form submissions after deploying.

### 3. Vite 5 config
Check `vite.config.js` — the `laravel-vite-plugin` 1.x API is compatible but
any custom Vite plugins you added may need updates.

### 4. Delete `composer.lock` and `package-lock.json` before first install
These lock files reference old resolved versions and should be regenerated:
```bash
rm composer.lock package-lock.json
composer install
npm install
```
