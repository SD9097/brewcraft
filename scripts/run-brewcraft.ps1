# Run BrewCraft with a clean rebuild (fixes Flutter Demo counter showing)
$ErrorActionPreference = "Stop"
Set-Location "E:\brewcraft"

Write-Host "Project: $(Get-Location)"
Write-Host "main.dart starts with:"
Get-Content "lib\main.dart" -TotalCount 3

if (-not (Test-Path "lib\app\app.dart")) {
    Write-Error "Wrong folder - lib\app\app.dart missing. Run: cd E:\brewcraft"
}

Write-Host ""
Write-Host "==> flutter create (web platform)..."
flutter create . --project-name brewcraft --org com.brewcraft --platforms=web

Write-Host ""
Write-Host "==> flutter clean..."
flutter clean

Write-Host ""
Write-Host "==> flutter pub get..."
flutter pub get

Write-Host ""
Write-Host "==> Starting BrewCraft on Chrome (port 8080)..."
Write-Host "    Expected: How are you brewing today?"
Write-Host "    NOT the Flutter counter demo."
Write-Host ""
flutter run -d chrome --web-port=8080 `
  --web-header=Cross-Origin-Opener-Policy=same-origin `
  --web-header=Cross-Origin-Embedder-Policy=require-corp
