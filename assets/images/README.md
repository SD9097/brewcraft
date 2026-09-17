# BrewCraft sample images

Images are **not stored in the database** — only path strings like `assets/images/coffees/ethiopian_yirgacheffe.jpg`.

## Download sample photos (one time)

From project root:

```powershell
cd E:\brewcraft
.\scripts\download-sample-images.ps1
```

This downloads royalty-free coffee photos from Unsplash into:

- `assets/images/coffees/` — hero images (12 coffees)
- `assets/images/steps/` — brew step placeholders
- `design/stitch/screens/` — Stitch UI reference screenshots (optional)

Until you run the script, cards show a placeholder icon. The app still works offline after images are downloaded.

## User uploads

Personal photos are saved under the app documents folder (`user_uploads/`), not here.
