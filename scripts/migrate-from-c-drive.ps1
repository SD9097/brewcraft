# One-time: copy project from old C: location to E:\brewcraft (if needed)
$src = "C:\Users\admin\Projects\coffee_guide"
$dst = "E:\brewcraft"
if (Test-Path $src) {
    Write-Host "Copying from $src to $dst ..."
    New-Item -ItemType Directory -Force -Path $dst | Out-Null
    robocopy $src $dst /E /XD build .dart_tool .git /NFL /NDL /NJH /NJS
    Write-Host "Done. Open folder: $dst"
} else {
    Write-Host "Source not found. Project should already be at $dst"
}
