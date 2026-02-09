$Url = "https://www.nhm.at/verlag/wissenschaftliche_publikationen/annalen_serie_b/105_2003"
$DownloadFolder = ".\NHM_PDFs"

# Zielordner anlegen
if (-not (Test-Path $DownloadFolder)) {
    New-Item -ItemType Directory -Path $DownloadFolder | Out-Null
}

$response = Invoke-WebRequest -Uri $Url

$pdfLinks = $response.Links |
    Where-Object { $_.href -match "\.pdf$" } |
    ForEach-Object { $_.href }

$pdfLinks = $pdfLinks | ForEach-Object {
    if ($_ -notmatch "^https?://") {
        [Uri]::new($Url, $_).AbsoluteUri
    } else {
        $_
    }
}

foreach ($pdf in $pdfLinks) {
    $filename = Split-Path $pdf -Leaf
    $target = Join-Path $DownloadFolder $filename
    Write-Host "Lade herunter: $filename"
    Invoke-WebRequest -Uri $pdf -OutFile $target
}

Write-Host "Alle PDFs wurden in $DownloadFolder gespeichert."