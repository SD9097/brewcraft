# BrewCraft — Development Log

This file records **what** was built, **why** it was built that way, and **when**.  
Read this alongside `README.md` (user-facing) and `docs/GIT_WORKFLOW.md` (branch rules).

**Project location:** `E:\brewcraft`

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
