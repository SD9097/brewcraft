# Download Drift web assets required for SQLite in Chrome.
# Match versions to pubspec.lock: drift 2.28.x, sqlite3 2.9.x wasm build.
$ErrorActionPreference = "Stop"
Set-Location "E:\brewcraft"

$webDir = "web"
New-Item -ItemType Directory -Force -Path $webDir | Out-Null

Write-Host "Downloading sql.js for WebDatabase (web fallback)..."
curl.exe -L "https://cdn.jsdelivr.net/npm/sql.js@1.10.3/dist/sql-wasm.js" -o "$webDir\sql-wasm.js"
curl.exe -L "https://cdn.jsdelivr.net/npm/sql.js@1.10.3/dist/sql-wasm.wasm" -o "$webDir\sql-wasm.wasm"

Write-Host "Downloading sqlite3.wasm (native / future wasm path)..."
# Must match sqlite3 version in pubspec.lock (3.6.x).
curl.exe -L "https://github.com/simolus3/sqlite3.dart/releases/download/sqlite3-3.6.0/sqlite3.wasm" -o "$webDir\sqlite3.wasm"

Write-Host "Downloading drift_worker.js..."
curl.exe -L "https://github.com/simolus3/drift/releases/download/drift-2.28.2/drift_worker.js" -o "$webDir\drift_worker.js"

Write-Host ""
Write-Host "Done. Web folder now has:"
Get-ChildItem $webDir -Name
