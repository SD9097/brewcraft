# BrewCraft ☕

A beautiful, fast coffee guide for **phone, tablet, and web**.

**Project folder:** `E:\brewcraft`

---

## Quick start (developers)

```powershell
cd E:\brewcraft
.\scripts\setup.ps1
flutter run -d chrome
```

See full instructions below for non-technical users and GitHub setup.

---

## What can you do?

1. **Pick how you brew** — Pour-over, French press, Espresso, Moka, South Indian filter, Instant, and more.
2. **Explore coffees** — Beans by region with tasting notes and sensory profiles.
3. **Follow brew guides** — Step-by-step with timings and ratios.
4. **Make it yours** — Custom recipes, ingredients, notes, and your own photos.
5. **Works offline** — Content stored on your device.

---

## For non-technical users — how to install

### On your phone (Android)
Ask a developer to build an APK, or follow the developer setup below.

### On your computer (Web)
After setup, run `flutter run -d chrome` — the app opens in your browser.

### On Windows desktop
```bash
flutter run -d windows
```

---

## Developer setup

### 1. Install Flutter
Download from https://docs.flutter.dev/get-started/install  
Then run: `flutter doctor`

### 2. Open the project
```powershell
cd E:\brewcraft
```

### 3. First-time setup
```powershell
.\scripts\setup.ps1
```

### 4. Run the app
```powershell
flutter run -d chrome
```

---

## Tech stack

| Piece | Purpose |
|---|---|
| Flutter | Android, iOS, web, Windows |
| Riverpod | App state |
| Drift (SQLite) | Local database |
| go_router | Navigation & web URLs |
| image_picker | User photo uploads |

---

## Docs

- `DEVLOG.md` — what we built and why
- `docs/GIT_WORKFLOW.md` — branches & GitHub rules
- `docs/ARCHITECTURE.md` — technical design

---

*Built with warmth — like a good cup of coffee.* ☕
