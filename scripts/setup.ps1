# BrewCraft — first-time project setup (run in PowerShell)
$ErrorActionPreference = "Stop"
Set-Location "E:\brewcraft"

Write-Host "==> Flutter create (platform folders)..."
flutter create . --project-name brewcraft --org com.brewcraft --platforms=web,android,windows

Write-Host "==> Get dependencies..."
flutter pub get

Write-Host "==> Optional: download Stitch design screenshots..."
if (Test-Path "design\stitch\download-assets.ps1") {
    & "design\stitch\download-assets.ps1"
}

Write-Host "==> Git init (if needed)..."
if (-not (Test-Path ".git")) {
    git init -b main
    git add .
    git commit -m "Initial commit: BrewCraft scaffold, docs, and brew-category home"
}

Write-Host "==> Create GitHub repo (public: brewcraft)..."
Write-Host "Run manually if not done:"
Write-Host "  gh auth login"
Write-Host "  gh repo create brewcraft --public --source=. --remote=origin --push"

Write-Host "Done. Run: flutter run -d chrome"
