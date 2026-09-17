# Download royalty-free sample images for BrewCraft (Unsplash)
$ErrorActionPreference = "Stop"
Set-Location "E:\brewcraft"

$coffeeDir = "assets\images\coffees"
$stepsDir = "assets\images\steps"
$stitchDir = "design\stitch\screens"
New-Item -ItemType Directory -Force -Path $coffeeDir, $stepsDir, $stitchDir | Out-Null

Write-Host "Downloading coffee hero images..."
$images = @{
    "ethiopian_yirgacheffe.jpg" = "https://images.unsplash.com/photo-1447933601403-0c6688de566e?auto=format&fit=crop&w=800&q=80"
    "colombian_huila.jpg" = "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=800&q=80"
    "indian_malabar.jpg" = "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80"
    "sumatra_mandheling.jpg" = "https://images.unsplash.com/photo-1447933601403-0c6688de566e?auto=format&fit=crop&w=800&q=80"
    "turkish_blend.jpg" = "https://images.unsplash.com/photo-1511920170033-f8396924c10b?auto=format&fit=crop&w=800&q=80"
    "kenyan_aa.jpg" = "https://images.unsplash.com/photo-1495474472287-4d71bcdd2085?auto=format&fit=crop&w=800&q=80"
    "guatemala_antigua.jpg" = "https://images.unsplash.com/photo-1461023058943-07fcbe16d735?auto=format&fit=crop&w=800&q=80"
    "costa_rica_tarrazu.jpg" = "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=800&q=80"
    "brazil_santos.jpg" = "https://images.unsplash.com/photo-1442512595331-e89e73853f31?auto=format&fit=crop&w=800&q=80"
    "vietnam_robusta.jpg" = "https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?auto=format&fit=crop&w=800&q=80"
    "instant_coffee.jpg" = "https://images.unsplash.com/photo-1517487881594-2787fef5ebf7?auto=format&fit=crop&w=800&q=80"
    "panama_geisha.jpg" = "https://images.unsplash.com/photo-1442512595331-e89e73853f31?auto=format&fit=crop&w=800&q=80"
    "brew_pour_over.jpg" = "https://images.unsplash.com/photo-1498804103079-a6351b050096?auto=format&fit=crop&w=800&q=80"
    "brew_french_press.jpg" = "https://images.unsplash.com/photo-1498804103079-a6351b050096?auto=format&fit=crop&w=800&q=80"
    "brew_espresso.jpg" = "https://images.unsplash.com/photo-1510591509098-f4fdc6d0ff04?auto=format&fit=crop&w=800&q=80"
}

foreach ($entry in $images.GetEnumerator()) {
    $out = if ($entry.Key.StartsWith("brew_")) { Join-Path $stepsDir $entry.Key } else { Join-Path $coffeeDir $entry.Key }
    Write-Host "  $($entry.Key)"
    curl.exe -L $entry.Value -o $out
}

Write-Host ""
Write-Host "Downloading Stitch UI reference screenshots (optional)..."
$stitch = @{
    "coffee-list.png" = "https://lh3.googleusercontent.com/aida/AEtjO1Xi9LLuL3ilJmnEDKoHlYs8YcvUwV4kUkts0lHa7j3OJVUPtO1mQ9TtDkPfnBUw7foh8c0pYrLG1aDof9gqCWqAb31AJwGRzAEp-BD9fZ3mll6YouCskT8x4FAU-t2_VRpgFef2pm8qioN4hYAPRLgcq1mKvEgDrU9IPfMn1Oeb0sCZ8_KzANFNyXev-DYJDzoDlRQQo-4ZwrgxOfnk8UK6nWNTKQUOyY4x0HghP-ZCVJRYBJts7SPXHFg"
    "coffee-detail.png" = "https://lh3.googleusercontent.com/aida/AEtjO1VR1md9WLav52dxwcOQO0PM2wswI2CVEjmS87IOsz5DuiL7h0wmYGVhtXNbN3AGAJ1GaU97PTodAdrokndatbULUXX2AAWrpujhxm6a-ixBVPb9nBHmDoKWhgtq5iZdTEHZgNoO_GrWsYAILFbLGZzGjAkXJNR1G3kUt9oI4I8_5ulvfPQo5PrcjXijjnQ4zlczqhUeAqqgXwKNTSkqAlFGSj-FHiGB8VhUUiKp4poUbstaDPUtSQJeAQ"
    "preparation-guide.png" = "https://lh3.googleusercontent.com/aida/AEtjO1XtakE-QsPMPfPeXRcvetFMxKT5QBprVxrvrz2s1ynnZk2UuW7fdcZiXSEMwqcLQJtjLaiJFj4NUr8ZZuK44A6l-iMyylu84MUaN1dV_GOfhnijtzDApmqmXS0CJo9Wac0cKQYaJ_S938nqdBD_XFrx3tMILJg1TUTaFQFxc2Qmc4-aG25-FYiMF8Jf3ZLBzOB5qK6eI2UQ7Lf7_u9Jie-iD894xvWhI2_L2R63Ku4KDxBw0NtCVWbhweU"
}
foreach ($entry in $stitch.GetEnumerator()) {
    Write-Host "  $($entry.Key)"
    curl.exe -L $entry.Value -o (Join-Path $stitchDir $entry.Key)
}

Write-Host ""
Write-Host "Done. Restart the app: flutter run -d chrome"
