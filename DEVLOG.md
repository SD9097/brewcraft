# BrewCraft — Development Log

This file records **what** was built, **why** it was built that way, and **when**.  
Read this alongside `README.md` (user-facing) and `docs/GIT_WORKFLOW.md` (branch rules).

**Project location:** `E:\brewcraft`

---

## 2026-09-17 — Git connected to GitHub

### What
- Remote: `https://github.com/SD9097/brewcraft.git`
- Initial commit `50d7496` on `main`, pushed successfully.

### Why
- Version control + backup before feature branches.

---

## 2026-09-17 — Fix first `flutter run` build errors

### What
- Created `assets/images/coffees/` and `assets/images/methods/` (required by pubspec).
- Fixed `NavigationRail` compile error (removed invalid `const` on widget).
- Setup script now runs `flutter create` with `--platforms=web,android,windows`.

### Why
- Flutter requires asset directories to exist when listed in `pubspec.yaml`.
- `const NavigationRail(...)` fails when `selectedIndex` is set (assert uses `destinations.length`).
- Web folder was missing so Chrome target could not launch.

---

## 2026-09-17 — Moved project to E: drive

### What
- Relocated project from `C:\Users\admin\Projects\coffee_guide` to **`E:\brewcraft`**.

### Why
- User requested all project files on the E: drive.

### Branch
- `feature/scaffold-app`

---

## 2026-09-17 — Project kickoff

### What
- Initialized BrewCraft repository structure and documentation.
- Imported Stitch design tokens (`design/stitch/DESIGN.md`, `colors.json`).
- Defined architecture: Flutter + Riverpod + Drift + go_router.
- Chose **brew-category-first** navigation.

### Why
- Brew method first matches how users actually choose coffee at home.
- Local-first + hybrid images for speed and offline use.
- Branch-per-feature + main approval for production safety.

### Next steps
1. Run `E:\brewcraft\scripts\setup.ps1`
2. `gh repo create brewcraft --public --source=. --remote=origin --push`
3. Continue on `feature/drift-schema` after your approval

---

## 2026-09-17 — Drift schema + seed data + sample images (`feature/drift-schema`)

### What
- Added Drift database (`lib/data/local/`) with tables: coffees, categories, flavor notes, brew methods, steps, ingredients, image overrides, app meta.
- Seeded **12 regional coffees** from `assets/seed/coffees.json` on first launch via `SeedLoader`.
- Replaced in-memory `seed_coffees.dart` with `CoffeeRepository` + Riverpod providers.
- Wired coffee list, detail, and brew guide screens to SQLite.
- Added `scripts/download-sample-images.ps1` — downloads Unsplash hero/step photos into `assets/images/coffees/` and `assets/images/steps/`.
- Added `assets/images/README.md` explaining where images live and how to download them.

### Why
- Local-first persistence matches the architecture decision (Drift, no BLOBs).
- Path strings in DB + bundled assets keeps images swappable and offline-friendly.
- Sample images are **not committed as binaries** — run the download script once so cards show real photos instead of placeholders.

### Run locally
```powershell
cd E:\brewcraft
flutter pub get
.\scripts\setup-drift-web.ps1
dart run build_runner build --delete-conflicting-outputs
.\scripts\download-sample-images.ps1
.\scripts\run-brewcraft.ps1
```

---

## 2026-09-17 — Fix Drift on Flutter web

### What
- Configured `DriftWebOptions` in `app_database.dart` (`sqlite3.wasm` + `drift_worker.js`).
- Added `scripts/setup-drift-web.ps1` to download required web assets into `web/`.
- Updated `run-brewcraft.ps1` with COOP/COEP headers for reliable SQLite on Chrome.

### Why
- `driftDatabase()` throws on web without the `web` parameter, which caused "Could not load coffees" on Chrome.

---

## 2026-09-17 — Web database fix (sql.js fallback)

### What
- Split database connection by platform: `connect_native.dart` (drift_flutter) vs `connect_web.dart` (Drift `WebDatabase` + sql.js).
- Added `sql-wasm.js` and `sql-wasm.wasm` to `web/` via `setup-drift-web.ps1`.
- Fixed conditional import to use `dart.library.html` / `dart.library.io`.

### Why
- Flutter web + `sqlite3.wasm` had a version mismatch (`xFileControl` import error). sql.js avoids that and loads the 12 seeded coffees reliably in Chrome.
