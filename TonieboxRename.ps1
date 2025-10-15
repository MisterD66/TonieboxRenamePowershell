# Pfad zur Toniebox-Musiksammlung
$basePath = "TODO" 

# Regex für das Muster: 8 Hex, Bindestrich, 8 Hex, " - Track #", zweistellige Zahl
$pattern = '^[0-9A-Fa-f]{8}-[0-9A-Fa-f]{8} - Track #(\d{2})$'

# Alle Audio-Dateien rekursiv durchsuchen
Get-ChildItem -Path $basePath -Recurse -File -Include *.ogg, *.mp3, *.wav, *.m4a | ForEach-Object {
    $file = $_
    $folderName = Split-Path $file.DirectoryName -Leaf
    $baseName = [System.IO.Path]::GetFileNameWithoutExtension($file.Name)

    # Prüfen, ob Dateiname dem Muster entspricht
    if ($baseName -match $pattern) {
        $trackNumber = $matches[1]
        $newName = "$folderName #$trackNumber$($file.Extension)"
        $newPath = Join-Path $file.DirectoryName $newName

        if ($file.Name -ne $newName) {
            Write-Host "Renaming '$($file.FullName)' → '$newName'"
            Rename-Item -Path $file.FullName -NewName $newName -Force
        }
    }
}
